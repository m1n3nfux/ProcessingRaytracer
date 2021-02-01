# ProcessingRaytracer
### A Simple Raytracing Script written in [Processing](https://processing.org)

Eine beliebige Anzahl beliebiger 3D Objekte lassen sich in einem virtuellen Raum mit Schatten darstellen.
Später können eventuell noch Field-Of-View / Perspektive, Spiegelungen und Bewegungen realisiert werden.

### Ressourcen, Links, Tips, Ideen, ...
#### Programmieren und so
- https://processing.org/reference/
- https://raytracing.github.io/books/RayTracingInOneWeekend.html#surfacenormalsandmultipleobjects/frontfacesversusbackfaces

#### Mathe und so
- https://www.scratchapixel.com/lessons/3d-basic-rendering/minimal-ray-tracer-rendering-simple-shapes/ray-sphere-intersection
- ( https://en.wikipedia.org/wiki/Line%E2%80%93sphere_intersection )

#### Beispiele & Tutorials
Raytracing Tutorialserie in Java *aus dem Fenster spring*
- https://youtube.com/playlist?list=PLNmsVeXQZj7rvhHip_LTM-J-5wHw7dWnw 
Raycasting in Processing Codebeispiel 
- https://forum.processing.org/two/discussion/comment/106556/#Comment_106556



### Roadmap
- √ Recherche zur Funktionsweise und Mathematik (Line-Sphere-Collision, etc.) 
- √ Gruppeneinteilung / Aufgabenverteilung
- √ Programmierung von einem sehr einfachen "ray-tracer", der die Objekte einfarbig und ohne Schatten darstellt
- √ Implementierung von Schatten und Refletionen (Auftreff-winkel, ...)
- √ Diffusion
- √ Lampen-Objekt (im Grunde eine weiße Kugel, die die Farbe eines Reflection Rays aufhellt (weiß))
- √ Einstellbare Relfektivität von Objekten
- FOV (field of view) (Rays in einem Winkel von der Kamera) => Perspektive
- Unterschiedliche Arten von Objekten



### Protokoll
(Alle Veränderungen / Updates auch unter Commits sichtbar)
#### Di. 12.01.2021 - Anfängliche Orga
Ergebnisse s. Oben ;)

#### Mi. 13.01.2021 
- Recherche
- Github Repository aufgesetzt ( https://github.com/m1n3nfux/ProcessingRaytracer/ )
- Ray-Klasse und Ray-Array mit Ray-Objekten erstellt
- Sphere-Klasse erstellt

#### Mi. 20.01.2021
- Render-Funktion erstellt
- Erster render
- Bugs:
  * Invertierte Farben
  * Mit den älteren Formeln teilweise gefixt
  * Sphere center verändert den Radius, nicht den Ort
  * Mit den älteren Formeln teilweise gefixt, Radius funktioniert, aber ort nicht.  

#### Di. 26.01.2021
- "Canvas shift" gefixed
- Code Cleanup
- Intersection-varibalen in die Ray-Klasse verschoben
- Normals berechnet
- Ray "cast" Funktion eingebaut und damit Grundgerüst für Schatten und Spiegelungen gelegt

#### Mi. 27.01.2021
- Mathematik zu "Einfallswinkel gleich Ausfallswinkel" im dreidimensionalen Raum recherchiert und angewandt
- => Wir können jetzt einen neuen Ray vom Auftreffpunkt des letzten aussenden (ein weiterer Schritt zu Schatten und Reflektionen)

#### Sa. 30.01.2021
- Negative Normals gefixed, Normals, die in Kugeln waren gefixed
- Cleanup
- Object-Klasse
- Objekt Reflektivität und Roughness

#### So. 30.01.2021
- Funktionen Objekt unabhängig gemacht
- Extra Datein für Objekt- und Ray-Klassen
- Cleanup (ray-array gelöscht und durch loop in draw() ersetzt)

#### Mo. 01.02.2021
- Rays können mit Background kollidieren -> Hintergrundfarbe beeinflusst Szene
- Plane-Klasse erstellt und mit Variablen gefüllt
