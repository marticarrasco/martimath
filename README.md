# martimath 1.0.2

Paquet personal de LaTeX per als apunts matemàtics de Martí Carrasco.

## Instal·lació ràpida

1. Descomprimeix el ZIP.
2. Copia **tots els fitxers `.sty`** a la mateixa carpeta que el teu `.tex`.
3. Compila amb `pdflatex` (dues vegades si has afegit índexs).
4. Carrega `\usepackage{martimath}` després de `\documentclass[a4paper]{article}`.
   El text tindrà **12 pt per defecte**. Per triar una altra mida,
   usa `\usepackage[fontsize=11pt]{martimath}` (o `10pt`, `13pt`, etc.).

Per instal·lar-lo globalment a TeX Live, copia els `.sty` a
`TEXMFHOME/tex/latex/martimath/` i executa `mktexlsr` si la instal·lació
ho requereix. Pots consultar la ruta personal exacta amb `kpsewhich -var-value=TEXMFHOME`.

## Instal·lació i publicació des de Windows

Des del directori del repo, executa `.\release.ps1` per instal·lar la versió
actual dels cinc fitxers `.sty` a `TEXMFHOME/tex/latex/martimath/`, actualitzar
la base de dades de TeX Live i crear `dist/martimath-v<versió>.zip`.

Per preparar i publicar una versió nova, executa:

~~~powershell
.\release.ps1 -Version 1.0.2 -Publish
~~~

L'opció `-Publish` mostra els canvis pendents i demana escriure el tag per
confirmar. Després actualitza la versió als cinc fitxers `.sty`, crea un commit,
instal·la els fitxers localment, crea i puja el tag i publica el ZIP com a asset
del release de GitHub. Revisa la llista de canvis abans de confirmar: el commit
inclou tots els canvis no ignorats del repo.

## Estil predeterminat

- Computer Modern **original** (no es carrega `lmodern`, `fontspec`, etc.).
- Títol del document amb `\maketitle`: alineat a l'esquerra, `\Large` i negreta;
  l'autor i la data, si n'hi ha, es mostren a sota.
- A4, **12 pt predeterminats** (configurables amb `fontsize` al paquet), marges d'1,5 cm.
- Seccions: vermell fort (`#C00000`), negreta, 14 pt; es conserva l'ús de majúscules i minúscules escrit per l'autor.
- Subseccions: vermell fort, negreta, 12 pt; també es conserva la capitalització escrita.
- Subsubseccions: negre, negreta, 11 pt, sense número.
- Definicions i resultats: etiqueta (`Def:`, `Obs:`, `Prop:`, etc.) en
  **negreta vermella**, nom opcional en vermell normal i cos en lletra normal;
  sense numeració.
- Peu de pàgina: número a la dreta; sense capçalera.
- Equacions no numerades amb `\[...\]` i numerades si s'usa `equation`.
- Demostracions: text més petit i blau; `Dem:` en negreta i quadrat final.
- `\emph{...}`: manté el format d'èmfasi de LaTeX i posa el text en blau clàssic;
  amb `colors=false` o `mode=print`, apareix en negre.

## Entorns: sintaxi

Noms d'entorns: `definicio`, `proposicio`/`prop`,
`observacio`/`obs`, `teorema`/`teo`, `lema`, `corollari`/`cor`,
`exemple`, `comentari`, `demostracio`/`dem`.

El nom entre claudàtors és **opcional**. El segon argument opcional
estableix les opcions visuals: `inline` (per defecte), `separat`,
`important` (línia vertical), i `index=false`.

~~~latex
\begin{definicio}[Ideal]
Un subconjunt ...
\end{definicio}

\begin{teo}[Isomorfisme][important,separat]
Enunciat ...
\begin{dem}
Demostració ...
\end{dem}
\end{teo}

\begin{obs}[][separat]
Observació sense subtítol...
\end{obs}
~~~

Per a demostracions llargues, pots col·locar `dem` o `demostracio`
després de l'entorn o dins d'ell. Si l'entorn és `important`, la línia
blava només acompanya l'enunciat, mai la demostració. En v1.0 es preveu
**com a màxim una demostració imbricada per resultat**, preferiblement
al final del contingut.

## Comandes curtes

Les comandes curtes tenen la mateixa API:

- `\defi[Nom][opcions]{contingut}`
- `\propi[Nom][opcions]{contingut}`
- `\obsi[Nom][opcions]{contingut}`
- `\teoi[Nom][opcions]{contingut}`
- `\lemai[Nom][opcions]{contingut}`
- `\cori[Nom][opcions]{contingut}`
- `\exi[Nom][opcions]{contingut}`
- `\comi[Nom][opcions]{contingut}`

**Nota important:** `\def` és una primitiva de TeX i no es redefineix.
Per això fem servir `definicio` com a entorn i `\defi{...}` com a comanda curta;
no es toca `\def`.

## Opcions globals

~~~latex
\usepackage[fontsize=12pt,mode=normal,spacing=normal,colors=true]{martimath}
~~~

- `mode=print`: negre i blanc, amb els mateixos formats.
- `mode=two-up`: dues pàgines A5 verticals sobre cada full A4 horitzontal.
  El document es compon directament en A5 amb text de 12 pt per defecte: **no s'encongeix**
  un A4 ja fet. Hi ha més salts de línia perquè les pàgines són més estretes.
  El marge és d'1 cm a esquerra i dreta, 1,1 cm a dalt i 1,3 cm a baix.
- `twoup=true`: activa la mateixa distribució, útil per combinar-la amb
  `mode=print` i obtenir dos A5 en blanc i negre.
- `fontsize=12pt`: mida del text principal (per defecte 12 pt; també es pot
  ajustar a `10pt`, `11pt`, `13pt`, etc.). Manté Computer Modern original.
- `spacing=compact`: menys espai vertical.
- `spacing=normal`: l'espaiat acordat.
- `spacing=relaxed`: més espai vertical.
- `colors=false`: sense vermell ni blau.

Per imprimir aprofitant un A4 horitzontal amb dues pàgines dretes:

~~~latex
\documentclass[a4paper]{article}
\usepackage[mode=two-up]{martimath}
~~~

O bé, en blanc i negre:

~~~latex
\usepackage[mode=print,twoup=true]{martimath}
~~~

En aquest mode cada meitat del full té numeració de pàgina pròpia; si
l'últim full només necessita una meitat, la segona queda en blanc.
Els enllaços dels índexs porten al full físic correcte, però la posició
exacta dins la meitat dreta pot ser imprecisa pel funcionament de
`pgfpages`; per a imprimir, els números de pàgina lògica són correctes.

## Índexs opcionals

`\tableofcontents` crea l'índex general habitual.
`\indexresultats` (o `\llistaresultats`) crea l'índex de resultats.
Els dos índexs tenen una presentació compacta i en negre, tant als
títols com als enllaços, independentment dels colors de la resta del document.
Tots els entorns de resultats hi entren per defecte; pots posar
`index=false` si no en vols algun. En els resultats sense nom, l'entrada
mostra només `Def:`, `Prop:`, etc. Els enllaços apunten al resultat.

## Figures

Per imatges externes: `\imatge[0.65\linewidth]{figura.png}[Llegenda opcional]`.
També pots utilitzar directament `\includegraphics`, `figure`, `tikzpicture`,
`tikzcd` i `pgfplots`.

Per a una gràfica ràpida:

~~~latex
\begin{grafica}[xmin=-2,xmax=2,ymin=-2,ymax=4]
  \plotfuncion[color=mmblue]{x^2-1}
  \plotfuncion[color=black,dashed]{x+0.2}
\end{grafica}
~~~

Les funcions es donen en sintaxi matemàtica de `pgfplots`; en expressar
coeficients decimals al codi s'usa el punt (per exemple `0.2`).

## Compatibilitat i comportament

- Recomanat: `pdflatex` i TeX Live amb els paquets estàndard de matemàtiques.
- Els títols tenen protecció bàsica contra salts inadequats de pàgina.
- El bloc amb línia vertical es pot dividir entre pàgines si és llarg.
- Les demostracions es poden partir entre pàgines.
- La biblioteca no modifica la sintaxi de `\ref` ni afegeix un sistema
  de referències creuades entre teoremes. Només utilitza hipervincles
  per als índexs.

## Fitxers

- `martimath.sty`: configuració principal.
- `martimath-layout.sty`: pàgina, títols i colors.
- `martimath-environments.sty`: resultats i demostracions.
- `martimath-index.sty`: índexs.
- `martimath-figures.sty`: gràfiques i imatges.
- `plantilla.tex`: punt de partida reutilitzable.
- `exemple.tex`: demostració de les funcionalitats.
- `exemple.pdf`: resultat compilat.
- `exemple_two_up.tex`: el mateix exemple en mode de dues pàgines per full.
- `exemple_two_up.pdf`: A4 horitzontal amb pàgines A5 sense reducció de lletra.
- `manual.tex` i `manual.pdf`: guia de dues pàgines.
- `tests/`: proves de modes d'impressió i salts de pàgina.
