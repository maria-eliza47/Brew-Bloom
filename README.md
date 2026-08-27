# Brew&Bloom - Sistem de gestiune al unei cafenele
## Tehnologii Utilizate

* **Bază de Date:** Oracle Database (Oracle SQL Developer)
* **Backend:** Node.js, Express.js (pachete: `oracledb`, `cors`, `express`)
* **Frontend:** HTML5, CSS3, Vanilla JavaScript (Fetch API)
* **Modelare & Design:** draw.io / Oracle Data Modeler

## Funcționalități (Cerințe Implementate)

Proiectul acoperă toate etapele de dezvoltare a unei baze de date, de la modelarea conceptuală până la interacțiunea printr-o interfață grafică:

1. **Modelare Teoretică:** Diagrame Entitate-Relație (E-R) și scheme relaționale.
2. **Arhitectură SQL:** 10 tabele interconectate (relații 1:1, 1:M, M:N rezolvate prin tabele asociative).
3. **Integritatea Datelor:** Constrângeri complexe (`PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `CHECK`, `DEFAULT`, `ON DELETE CASCADE`).
4. **Interfață Web (API REST):**
   * Listarea conținutului din baza de date direct în browser.
   * Operații de ștergere cu exemplificarea constrângerii `ON DELETE CASCADE`.
   * Interogări complexe (extragere din 3+ tabele, minim 2 condiții de filtrare).
   * Interogări cu funcții grup și clauza `HAVING`.
   * Utilizarea vizualizărilor (Views) simple și complexe.
