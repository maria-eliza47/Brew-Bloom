const express = require('express');
const oracledb = require('oracledb');
const cors = require('cors');
const path = require('path');

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(__dirname));

const dbConfig = {
    user: "cafenea_maria",
    password: "11042017",
    connectString: "localhost:1521/xe"
};

async function executeQuery(sql, binds = {}, opts = {}) {
    let connection;
    try {
        connection = await oracledb.getConnection(dbConfig);
        const options = {
            outFormat: oracledb.OUT_FORMAT_OBJECT,
            autoCommit: true,
            ...opts
        };
        const result = await connection.execute(sql, binds, options);
        return result;
    } finally {
        if (connection) {
            try {
                await connection.close();
            } catch (err) {
                console.error("Eroare inchidere conexiune:", err);
            }
        }
    }
}

// 1. LISTA TABELE
app.get('/api/tables', async (req, res) => {
    try {
        const result = await executeQuery(`SELECT table_name FROM user_tables ORDER BY table_name`);
        res.json(result.rows.map(r => r.TABLE_NAME));
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// CERINTA a) LISTARE & SORTARE
app.get('/api/tables/:tableName', async (req, res) => {
    const { tableName } = req.params;
    const { sort, order } = req.query;

    const validTables = [
        'CLIENT', 'COMANDA', 'PRODUS', 'CATEGORIE', 'MAGAZIN', 
        'LOCATIE', 'ANGAJAT', 'METODA_PLATA', 'DETALII_COMANDA', 'STOC'
    ];

    const upperTable = tableName.toUpperCase();
    if (!validTables.includes(upperTable)) {
        return res.status(400).json({ error: "Nume de tabel invalid!" });
    }

    try {
        let sql = `SELECT * FROM ${upperTable}`;
        let result;
        if (sort) {
            const cleanSort = sort.replace(/[^a-zA-Z0-9_]/g, '');
            const cleanOrder = (order && order.toUpperCase() === 'DESC') ? 'DESC' : 'ASC';
            try {
                result = await executeQuery(`${sql} ORDER BY ${cleanSort} ${cleanOrder}`);
            } catch (sortErr) {
                // Daca coloana nu apartine tabelului selectat, fallback la select simplu
                result = await executeQuery(sql);
            }
        } else {
            result = await executeQuery(sql);
        }

        const formattedData = result.rows.map(row => {
            const newRow = {};
            for (const [key, val] of Object.entries(row)) {
                if (val instanceof Date) {
                    newRow[key] = val.toISOString().split('T')[0];
                } else {
                    newRow[key] = val;
                }
            }
            return newRow;
        });

        res.json({
            table: upperTable,
            count: formattedData.length,
            data: formattedData
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// CERINTA b) CRUD: INSERT
app.post('/api/tables/:tableName', async (req, res) => {
    const upperTable = req.params.tableName.toUpperCase();
    const rawData = req.body;

    const columns = [];
    const binds = {};

    for (const [key, val] of Object.entries(rawData)) {
        const cleanKey = key.toUpperCase();
        columns.push(cleanKey);
        binds[cleanKey] = (val === '' || val === undefined) ? null : val;
    }

    if (columns.length === 0) {
        return res.status(400).json({ error: "Nu au fost trimise date pentru inserare!" });
    }

    const colsStr = columns.join(', ');
    const bindsStr = columns.map(c => `:${c}`).join(', ');
    const sql = `INSERT INTO ${upperTable} (${colsStr}) VALUES (${bindsStr})`;

    try {
        await executeQuery(sql, binds);
        res.json({ success: true, message: `Inregistrare adaugata cu succes in ${upperTable}!` });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// CERINTA b) CRUD: UPDATE
app.put('/api/tables/:tableName', async (req, res) => {
    const upperTable = req.params.tableName.toUpperCase();
    const { primaryKey, data } = req.body;

    if (!primaryKey || !data) {
        return res.status(400).json({ error: "Lipsesc datele pentru actualizare!" });
    }

    const setClauses = [];
    const binds = {};

    for (const [key, val] of Object.entries(data)) {
        const cleanKey = key.toUpperCase();
        setClauses.push(`${cleanKey} = :val_${cleanKey}`);
        binds[`val_${cleanKey}`] = (val === '' || val === undefined) ? null : val;
    }

    const whereClauses = [];
    for (const [key, val] of Object.entries(primaryKey)) {
        const cleanKey = key.toUpperCase();
        whereClauses.push(`${cleanKey} = :pk_${cleanKey}`);
        binds[`pk_${cleanKey}`] = val;
    }

    const sql = `UPDATE ${upperTable} SET ${setClauses.join(', ')} WHERE ${whereClauses.join(' AND ')}`;

    try {
        const result = await executeQuery(sql, binds);
        res.json({ success: true, rowsAffected: result.rowsAffected, message: "Date actualizate cu succes in Oracle!" });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// CERINTA b) CRUD: DELETE
app.delete('/api/tables/:tableName', async (req, res) => {
    const upperTable = req.params.tableName.toUpperCase();
    const primaryKey = req.query;

    if (Object.keys(primaryKey).length === 0) {
        return res.status(400).json({ error: "Cheia primara este obligatorie pentru stergere!" });
    }

    const whereClauses = [];
    const binds = {};

    for (const [key, val] of Object.entries(primaryKey)) {
        const cleanKey = key.toUpperCase();
        whereClauses.push(`${cleanKey} = :${cleanKey}`);
        binds[cleanKey] = val;
    }

    const sql = `DELETE FROM ${upperTable} WHERE ${whereClauses.join(' AND ')}`;

    try {
        const result = await executeQuery(sql, binds);
        res.json({ success: true, rowsAffected: result.rowsAffected, message: "Inregistrare stearsa cu succes!" });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// CERINTA c) CERERE COMPLEXA (3 TABELE + 2 CONDITII CU FILTRE DINAMICE)
app.get('/api/queries/complex-filter', async (req, res) => {
    const minTotal = parseFloat(req.query.minTotal) || 25.00;
    const status = req.query.status || 'Activ';

    let sql = `
        SELECT com.ID_Comanda, 
               cli.Nume || ' ' || cli.Prenume AS Nume_Client, 
               cli.Email, 
               cli.Telefon,
               mp.Tip_plata AS Metoda_Plata, 
               com.Total, 
               TO_CHAR(com.Data_Plasarii, 'YYYY-MM-DD') AS Data_Plasarii
        FROM Comanda com
        JOIN Client cli ON com.CNP = cli.CNP
        JOIN Metoda_Plata mp ON com.ID_Metoda = mp.ID_Metoda
        WHERE com.Total >= :minTotal
    `;

    const binds = { minTotal };
    if (status !== 'Toate') {
        sql += ` AND mp.Status = :status`;
        binds.status = status;
    }
    sql += ` ORDER BY com.Total DESC`;

    try {
        const result = await executeQuery(sql, binds);
        res.json({
            count: result.rows.length,
            minTotal,
            status,
            data: result.rows
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// CERINTA d) CERERE CU FUNCTII GRUP SI CLAUZA HAVING (CU FILTRE DINAMICE)
app.get('/api/queries/group-having', async (req, res) => {
    const minEmployees = parseInt(req.query.minEmployees) || 2;
    const minAvgSalary = parseFloat(req.query.minAvgSalary) || 3500.00;

    const sql = `
        SELECT m.Nume_Magazin, 
               COUNT(a.ID_Angajat) AS Numar_Angajati, 
               ROUND(AVG(a.Salariu), 2) AS Salariu_Mediu, 
               MIN(a.Salariu) AS Salariu_Minim,
               MAX(a.Salariu) AS Salariu_Maxim,
               SUM(a.Salariu) AS Total_Fond_Salarii
        FROM Magazin m
        JOIN Angajat a ON m.ID_Magazin = a.ID_Magazin
        GROUP BY m.Nume_Magazin
        HAVING COUNT(a.ID_Angajat) >= :minEmployees 
           AND AVG(a.Salariu) >= :minAvgSalary
        ORDER BY Salariu_Mediu DESC
    `;

    try {
        const result = await executeQuery(sql, { minEmployees, minAvgSalary });
        res.json({
            count: result.rows.length,
            minEmployees,
            minAvgSalary,
            data: result.rows
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// CERINTA e) ON DELETE CASCADE
app.get('/api/cascade/client-info/:cnp', async (req, res) => {
    const { cnp } = req.params;
    try {
        const clientRes = await executeQuery(`SELECT * FROM Client WHERE CNP = :cnp`, { cnp });
        const comenziRes = await executeQuery(`
            SELECT c.ID_Comanda, c.Total, TO_CHAR(c.Data_Plasarii, 'YYYY-MM-DD') AS Data_Plasarii,
                   COUNT(d.ID_Produs) AS Nr_Produse
            FROM Comanda c
            LEFT JOIN Detalii_Comanda d ON c.ID_Comanda = d.ID_Comanda
            WHERE c.CNP = :cnp
            GROUP BY c.ID_Comanda, c.Total, c.Data_Plasarii
        `, { cnp });

        res.json({
            client: clientRes.rows[0] || null,
            comenzi: comenziRes.rows
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.delete('/api/cascade/delete-client/:cnp', async (req, res) => {
    const { cnp } = req.params;
    try {
        const countBefore = await executeQuery(`SELECT COUNT(*) AS CNT FROM Comanda WHERE CNP = :cnp`, { cnp });
        const ordersCount = countBefore.rows[0].CNT;

        await executeQuery(`DELETE FROM Client WHERE CNP = :cnp`, { cnp });

        const countAfter = await executeQuery(`SELECT COUNT(*) AS CNT FROM Comanda WHERE CNP = :cnp`, { cnp });

        res.json({
            success: true,
            cnpSters: cnp,
            comenziSterseInCascada: ordersCount,
            comenziRamase: countAfter.rows[0].CNT,
            message: `Clientul cu CNP ${cnp} a fost sters. Datorita constrangerii ON DELETE CASCADE, toate cele ${ordersCount} comenzi asociate au fost eliminate automat din baza de date!`
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// CERINTA f) VIZUALIZARI (VIEWS)
app.get('/api/views/compusa', async (req, res) => {
    try {
        const result = await executeQuery(`SELECT * FROM V_PRODUS_CATEGORIE ORDER BY ID_Produs`);
        res.json({ data: result.rows });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.put('/api/views/compusa/update-price', async (req, res) => {
    const { idProdus, pretNou } = req.body;
    try {
        const result = await executeQuery(
            `UPDATE V_PRODUS_CATEGORIE SET Pret = :pretNou WHERE ID_Produs = :idProdus`,
            { pretNou: parseFloat(pretNou), idProdus: parseInt(idProdus) }
        );
        res.json({
            success: true,
            rowsAffected: result.rowsAffected,
            message: `Pretul produsului #${idProdus} a fost actualizat direct prin vizualizarea compusa la ${pretNou} lei!`
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.get('/api/views/complexa', async (req, res) => {
    const { sortCol } = req.query;
    let sql = `SELECT * FROM V_STATISTICI_MAGAZINE`;
    if (sortCol === 'salariu') {
        sql += ` ORDER BY Salariu_Mediu DESC`;
    } else if (sortCol === 'angajati') {
        sql += ` ORDER BY Numar_Angajati DESC`;
    } else {
        sql += ` ORDER BY ID_Magazin ASC`;
    }

    try {
        const result = await executeQuery(sql);
        res.json({ data: result.rows });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Serverul ruleaza pe http://localhost:${PORT}`);
});
