# martimath — PRD i estat del projecte

**Projecte:** `martimath`  
**Responsable:** Martí Carrasco  
**Data del traspàs:** 5 de novembre de 2026  
**Estat:** primera versió funcional (identificada al codi com a v1.0), pendent d'evolució  
**Idioma de treball i dels documents:** català per defecte

> Aquest document és el punt de partida per continuar el projecte amb Codex. Combina el perquè del producte, les decisions ja preses i el comportament real del codi. No és una petició de reimplementar-ho tot de zero.

## 1. Què és i per què existeix

`martimath` és una biblioteca d'estil LaTeX personalitzada per escriure **apunts universitaris de matemàtiques** amb una identitat visual constant. Es distribueix com un paquet que es carrega amb `\usepackage{martimath}`, sense haver de copiar un preàmbul llarg a cada assignatura.

El problema que resol és doble:

1. **Consistència:** seccions, teoremes, definicions, observacions, demostracions, fórmules, figures, marges i paginació han de tenir sempre un aspecte coherent.
2. **Rapidesa de redacció:** l'autor s'ha de concentrar en les matemàtiques i utilitzar ordres curtes i semàntiques, sense donar format manualment a cada resultat.

La filosofia visual és **moderna, minimalista, llegible i aprofitada**: els títols estructurals tenen una jerarquia clara, els resultats matemàtics s'identifiquen de seguida i només els enunciats especialment importants reben un accent lateral.

## 2. Abast del projecte

### Inclòs i ja implementat

- Un paquet LaTeX modular, importable des del preàmbul.
- Tipografia, pàgina, marges, seccions i subseccions estandarditzats.
- Entorns matemàtics sense numeració i amb subtítol opcional.
- Tres presentacions: text a la mateixa línia, text a sota i accent lateral opcional.
- Demostracions a dins o a fora del resultat.
- Índex general i índex de resultats, opcionals.
- Gràfics, imatges i accés a TikZ / pgfplots / diagrames commutatius.
- Opcions globals de mida de lletra, color, densitat i impressió.
- Mode de dues pàgines verticals en un sol full horitzontal.
- Plantilla, exemple visual, manual i proves de compilació.

### Expressament fora d'abast, de moment

- Entorns propis d'exercicis, solucions i contraexemples.
- Banc d'exercicis, fitxes de batxillerat o dossiers docents: aquest paquet se centra en **apunts matemàtics**.
- Numerar definicions, teoremes, proposicions, etc.
- Un sistema personalitzat de `\label`, `\ref` o referències creuades entre resultats.
- Canviar la tipografia per una font «semblant» a la de LaTeX: l'usuari vol **Computer Modern original**.

No s'han d'afegir aquestes funcions sense una petició posterior.

## 3. Decisions visuals definitives

| Element | Comportament acordat |
|---|---|
| Paper normal | A4 vertical |
| Marges normals | 1,5 cm |
| Mida de lletra | 12 pt per defecte; configurable amb `fontsize=...` |
| Font | Computer Modern original, sense `lmodern` ni substitucions |
| Títol del document | A l'esquerra, `\Large` i negreta; autor i data a sota |
| Color de seccions i subseccions | Vermell fort `mmred = #C00000` |
| Seccions | Numerades, respecten les majúscules i minúscules escrites per l'autor, negreta, 14 pt |
| Subseccions | Numerades, respecten les majúscules i minúscules escrites per l'autor, negreta, 12 pt |
| Subsubseccions | Negres, discretes, sense número |
| Salts de pàgina dels títols | Es reserva espai perquè els encapçalaments no quedin orfes al peu de pàgina |
| Títols de resultats | Vermell fort `mmred = #C00000` |
| Etiquetes `Def:`, `Obs:`, etc. | Vermell fort i **negreta**; el nom opcional és vermell normal |
| Cos dels resultats | Lletra normal (sense cursiva automàtica) |
| Resultats matemàtics | **Sense numeració** |
| Accent d'importància | Barra vertical blava **només quan s'indica** |
| Barra i demostració | La barra arriba només a l'enunciat, **mai** a `Dem:` |
| Demostracions | Text en mida petita i blau `mmblue`; `Dem:` en negreta i quadrat final |
| Èmfasi amb `\emph{...}` | Blau clàssic de LaTeX; negre quan es desactiven els colors |
| Capçalera | Cap |
| Peu | Número de pàgina alineat a la dreta |
| Equacions | Sense número amb `\[...\]`; amb número quan s'usa `equation` |
| Separació | Equilibrada; una mica més aire al voltant de les equacions i sobretot entre resultats consecutius |
| Índexs | Compactes i negres, encara que els resultats siguin vermells |

**Important per a Codex:** aquesta taula recull l'objectiu visual. A `11. Limitacions i punts a comprovar` s'anota una diferència menor detectada entre documentació i implementació del tercer nivell de seccions.

## 4. Sintaxi pública que ha de conservar-se

### 4.1. Document mínim

~~~latex
\documentclass[a4paper]{article}
\usepackage{martimath}

\begin{document}
\section{Anells}
\begin{definicio}[Ideal]
Sigui $A$ un anell...
\end{definicio}
\end{document}
~~~

### 4.2. Entorns de resultats

| Entorn principal | Àlies | Etiqueta visible |
|---|---|---|
| `definicio` | — | **Def:** |
| `proposicio` | `prop` | **Prop:** |
| `observacio` | `obs` | **Obs:** |
| `teorema` | `teo` | **Teorema:** |
| `lema` | — | **Lema:** |
| `corollari` | `cor` | **Cor:** |
| `exemple` | — | **Exemple:** |
| `comentari` | — | **Comentari:** |
| `demostracio` | `dem` | **Dem:**, amb quadrat final |

**No** s'imprimeixen nombres com `Teorema 1.3` o `Definició 2`. Només apareix l'etiqueta, un subtítol opcional i l'enunciat.

La signatura dels entorns de resultat és:

~~~latex
\begin{proposicio}[Nom opcional][opcions opcionals]
  Contingut...
\end{proposicio}
~~~

El **primer** argument entre claudàtors és un nom opcional; si falta, no es mostra cap `[]` buit. El **segon** controla l'estil:

- `inline`: etiqueta, nom i text inicial a la mateixa línia (predeterminat).
- `separat`: etiqueta i nom en una línia; l'enunciat comença a la següent.
- `important`: activa la barra vertical de l'enunciat.
- `index=false`: omet aquest resultat de l'índex de resultats.

Si cal indicar una opció sense nom, s'escriu `[][separat]`.

~~~latex
\begin{definicio}[Anell quocient]
Sigui $A$ un anell...
\end{definicio}

\begin{definicio}[Anell quocient][separat]
Sigui $A$ un anell...
\end{definicio}

\begin{definicio}
Sigui $A$ un anell...
\end{definicio}

\begin{teorema}[Primer teorema d'isomorfisme][important,separat]
Enunciat...
\begin{dem}
Demostració...
\end{dem}
\end{teorema}
~~~

Les demostracions poden anar també **després** del resultat:

~~~latex
\begin{lema}
Enunciat...
\end{lema}
\begin{demostracio}
Demostració...
\end{demostracio}
~~~

La línia vertical no envolta mai la demostració, encara que `dem` aparegui dins del resultat.

### 4.3. Comandes curtes

Existeixen `\defi`, `\propi`, `\obsi`, `\teoi`, `\lemai`, `\cori`, `\exi` i `\comi`. Accepten el nom, les opcions i el contingut:

~~~latex
\propi[Ideals principals]{Tot ideal principal és finitament generat.}
\obsi[][separat]{Una observació sense títol.}
~~~

**Mai no s'ha de redefinir `\def`**, perquè és una primitiva de TeX. Per a definicions, la forma curta és `\defi`.

## 5. Índexs i equacions

L'autor pot posar-los on vulgui amb:

~~~latex
\tableofcontents
\indexresultats
~~~

També s'admet `\llistaresultats` com a àlies de `\indexresultats`.

- Els dos índexs tenen títol i entrades **negres**, amb poc espai vertical.
- L'índex de resultats recull definicions, proposicions, teoremes, lemes, etc.; les etiquetes hi apareixen en negreta.
- Les entrades tenen números de pàgina i enllaços interns clicables.
- La inclusió de resultats és automàtica, tret que s'indiqui `index=false`.
- No hi ha numeració automàtica d'equacions globals: l'autor tria entre `\[...\]` i `equation`.

Per actualitzar bé els índexs cal compilar el document com a mínim dues vegades, o utilitzar `latexmk`.

## 6. Imatges, gràfiques i diagrames

La biblioteca carrega `graphicx`, `tikz`, `pgfplots` i `tikz-cd`.

Per inserir una imatge amb amplada i llegenda opcionals:

~~~latex
\imatge[0.65\linewidth]{figura.png}[Llegenda opcional]
~~~

Si no s'especifica l'amplada, el codi actual de `\imatge` utilitza `0.8\linewidth`; la llegenda es pot ometre.

Per fer una gràfica:

~~~latex
\begin{grafica}[xmin=-2,xmax=2,ymin=-2,ymax=4]
  \plotfuncion[color=mmblue]{x^2-1}
\end{grafica}
~~~

També es pot emprar LaTeX/TikZ directament. Les imatges i gràfiques no han de tenir necessàriament llegenda.

## 7. Modes i configuració del preàmbul

~~~latex
\usepackage[
  fontsize=12pt,
  mode=normal,
  spacing=normal,
  colors=true
]{martimath}
~~~

| Opció | Valors / efecte |
|---|---|
| `fontsize` | `12pt` per defecte; s'han provat altres mides, com `10pt` |
| `mode=normal` | Aspecte habitual en color |
| `mode=print` | Blanc i negre |
| `mode=two-up` | Dues pàgines A5 verticals per full físic A4 horitzontal |
| `twoup=true` | Activa dues pàgines per full, combinable amb `mode=print` |
| `colors=true/false` | Activa o desactiva vermell i blau |
| `spacing=compact/normal/relaxed` | Controla la densitat vertical global |

### 7.1. Funcionament exacte del mode two-up

~~~latex
\documentclass[a4paper]{article}
\usepackage[mode=two-up]{martimath}
~~~

- El codi compon **pàgines lògiques A5 verticals**, una a cada meitat del full físic.
- El PDF resultant té **fulls A4 horitzontals** amb dos A5 de costat.
- La font base manté **12 pt reals per defecte**, sense reduir un A4 preexistent.
- Marges A5 actuals: 1 cm als costats, 1,1 cm a dalt i 1,3 cm a baix.
- En una pàgina més estreta hi pot haver més salts de línia i més pàgines lògiques.
- Si hi ha un nombre senar de pàgines A5, la meitat dreta de l'últim full queda buida.
- Per a una impressió fidel, convé seleccionar **mida real / 100%** al diàleg d'impressió.

Per obtenir el mateix disseny en blanc i negre:

~~~latex
\usepackage[mode=print,twoup=true]{martimath}
~~~

## 8. Organització del codi

| Fitxer | Responsabilitat actual |
|---|---|
| `martimath.sty` | Punt d'entrada, opcions globals i càrrega dels mòduls |
| `martimath-layout.sty` | Geometry, paper, marges, colors, seccions, espaiat, peu i `pgfpages` |
| `martimath-environments.sty` | Resultats, opcions de cada bloc, negreta, barra i demostracions |
| `martimath-index.sty` | Índex general, fitxer auxiliar de resultats, enllaços i numeració en two-up |
| `martimath-figures.sty` | Imatges, gràfics, TikZ i pgfplots |
| `plantilla.tex` | Document inicial per a l'usuari |
| `exemple.tex` / `exemple.pdf` | Mostra del format normal |
| `exemple_two_up.tex` / `exemple_two_up.pdf` | Mostra del format A4 horitzontal amb dos A5 |
| `manual.tex` / `manual.pdf` | Guia d'ús |
| `tests/` | Proves de modes, salts de pàgina i opcions d'impressió |
| `README.md` | Instal·lació i referència ràpida |
| `PRD.md` | Propòsit, decisions, estat i traspàs a Codex |
| `AGENTS.md` | Instruccions de treball per a Codex |

No s'ha inicialitzat encara cap repositori Git dins del directori de lliurament. El paquet s'ha anat distribuint com a ZIP amb fonts i PDF d'exemple.

## 9. Entorn de compilació i comprovacions ja efectuades

- Compilació amb `pdflatex` (TeX Live disponible a l'entorn de desenvolupament).
- `latexmk -pdf` per repetir compilacions i generar índexs.
- Verificació del mode normal, `mode=print`, `mode=two-up` i la combinació `mode=print,twoup=true`.
- PDF two-up verificat com a **A4 horitzontal**; mida lògica comprovada com a A5 i lletra base com a **12 pt**.
- Mostres PDF renderitzades i revisades visualment: barra només a l'enunciat, colors, negreta, peu, gràfica i doble pàgina.
- Proves d'alguns salts de pàgina i protecció bàsica dels títols mitjançant `needspace`.
- L'arxiu ZIP comprovat amb `unzip -t` sense errors.

Comprovació típica des del directori del projecte:

~~~bash
latexmk -pdf -interaction=nonstopmode -halt-on-error exemple.tex
latexmk -pdf -interaction=nonstopmode -halt-on-error exemple_two_up.tex
latexmk -pdf -interaction=nonstopmode -halt-on-error manual.tex
~~~

En canvis futurs cal inspeccionar els PDF, no només comprovar el codi de retorn del compilador.

## 10. Criteris per acceptar canvis futurs

1. El document de prova normal continua compilant i manté la identitat visual.
2. No es renumeren els resultats i no s'introdueix cursiva al cos dels teoremes.
3. Les etiquetes segueixen en vermell fort i negreta; els índexs continuen negres.
4. La barra `important` no arriba a la demostració.
5. Els modes normal, print i two-up continuen funcionant.
6. La font Computer Modern original es manté i el two-up no redueix la lletra base.
7. Les pàgines i els enllaços dels índexs no es degraden sense documentar-ho.
8. Els exemples i el manual s'actualitzen quan canvia l'API.

## 11. Limitacions i punts a comprovar

**Diferències o limitacions conegudes del codi actual; no s'han de confondre amb tasques ja resoltes:**

1. **Mida del tercer nivell:** el `README.md` anterior indicava «subsubseccions de 11 pt», però el codi de `martimath-layout.sty` utilitza `\normalsize`: amb el valor predeterminat actual, això equival a **12 pt**. La jerarquia discreta en negre i sense número sí que funciona. Cal confirmar amb Martí si vol fixar explícitament 11 pt abans de modificar-ho.
2. **Two-up i destinacions PDF:** els números de pàgina dels índexs corresponen a la pàgina A5 correcta, però alguns enllaços poden portar al full A4 físic sense ajustar la posició exacta a la meitat dreta. És una limitació de la imposició amb `pgfpages`.
3. **Demostracions imbricades:** el disseny actual pressuposa una sola demostració a dins de cada resultat, situada preferiblement al final. La barra es tanca abans de la demostració; no hi ha mecanisme per reobrir-la després.
4. **Fonts matemàtiques molt petites:** en algunes compilacions PDF s'han observat substitucions puntuals de mides òptiques inferiors a les disponibles per a Computer Modern; no s'ha substituït la família tipogràfica general.
5. **Comportament en documents extensos:** cal continuar provant salts de pàgina, equacions llargues, índexs grans i imatges grosses, especialment en A5.
6. **Publicació i instal·lació:** `release.ps1` permet instal·lar els cinc fitxers `.sty` al `TEXMFHOME` de TeX Live. Amb `-Version x.y.z -Publish`, actualitza les metadades de versió, crea el ZIP, instal·la el paquet, fa push de `main` i del tag, i publica el release de GitHub. No hi ha CI.

## 12. Com continuar amb Codex

1. Treballar **sobre els fitxers existents**, no crear una biblioteca nova des de zero.
2. Llegir aquest PRD, `AGENTS.md` i `README.md` abans d'editar.
3. Quan es demani un canvi visual, compilar **tant l'exemple normal com el two-up** i comparar-los.
4. Resoldre primer les inconsistències reals que l'usuari vulgui prioritzar; no alterar preferències confirmades per «millorar» el disseny.
5. Mantenir els exemples curts, matemàticament correctes i en català.
6. Registrar qualsevol canvi de comportament públic a la documentació i conservar les proves de regressió.

**Objectiu final:** que Martí pugui escriure apunts de qualsevol assignatura de matemàtiques amb una única importació i una sintaxi breu, i obtenir sempre documents que ell reconegui com a propis.
