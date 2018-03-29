# bericht-anonimizer
XSLT template en procedures voor anonimiseren van basisregistratieberichten.


## met Maven

`mvn -Dxmlsrcdir=/tmp/xmlbron -Dxmloutputdir=/tmp/xmlanon`

Getransformeerde bestanden krijgen `.anon.xml` extensie, de default output directory is `target`.


## commandline

Draai 1x de `mvn` om de dependencies te downloaden naar de `lib` directory of zet daar met de hand een juiste [1] Saxon en een commons-codec .jar file in.

`java -cp "lib/*" net.sf.saxon.Transform -xsl:src/main/xsl/copy_xml.xsl  -s:/tmp/xml/bron.xml -o:/tmp/xml/bron.anon.xml`

[1]: *Er is een versie nodig die het uitroepen naar een java functie ondersteund, dat zijn actuele versies van Saxon-PE of Saxon-HE of oudere versies van Saxon-B.*
