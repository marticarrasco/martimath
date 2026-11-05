# Instruccions per a Codex — martimath

Aquest projecte és una biblioteca LaTeX personal per als apunts de matemàtiques de Martí Carrasco.

## Context obligatori

1. Llegeix `PRD.md`: hi ha el propòsit, les preferències tancades, l'API real, l'estat de la implementació i les limitacions.
2. Llegeix `README.md` per a exemples d'ús i instal·lació.
3. Inspecciona els cinc fitxers `martimath*.sty` abans de modificar les macros.

## Invariants que cal preservar

- Català per defecte; Computer Modern **original**.
- Mida base predeterminada de 12 pt, configurable al preàmbul.
- Sense numeració de definicions, teoremes, proposicions, observacions, lemes, corol·laris ni exemples.
- Etiquetes dels resultats blaves i en negreta, amb `:` final; nom opcional blau normal.
- Cos dels resultats en lletra normal.
- Seccions i subseccions vermelles; subsubseccions discretes, negres i sense número.
- Índex general i de resultats compactes i negres.
- Barra vertical només amb `important` i mai sobre la demostració.
- `Dem:` en negreta i quadrat final.
- Peu amb número a la dreta; sense capçalera.
- `mode=two-up`: dos A5 verticals per A4 horitzontal, sense reduir la font.
- No redefinir mai la primitiva TeX `\def`; la comanda curta és `\defi`.
- No afegir exercicis, solucions, contraexemples ni un sistema de referències internes sense demanar-ho.

## Flux de treball

- Edita els mòduls existents i mantén l'API compatible quan sigui possible.
- Compila amb `pdflatex` o `latexmk`; els índexs necessiten dues passades.
- Prova `exemple.tex`, `exemple_two_up.tex`, `manual.tex` i els fitxers de `tests/`.
- Revisa visualment els PDF i consulta `pdfinfo` per verificar les dimensions de full.
- Si canvia un comandament o una opció, actualitza `README.md`, `PRD.md` i els exemples.
- Distingeix els requisits confirmats dels punts pendents de `PRD.md`; no els modifiquis unilateralment.
- Comunica qualsevol limitació o incompatibilitat en comptes d'amagar-la.

## Estat tècnic

El projecte és funcional però encara no té repositori Git propi ni una pipeline de release. La distribució actual és un ZIP amb cinc fitxers `.sty`, plantilla, exemples, proves i documentació.
