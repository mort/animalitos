animalitos
==========


Player > Animalito

Player
========
Nombre

Puede moverse a una Location.

Puede hacer bond con una animalito existente o "criar" uno nuevo.

Puede hacer checkin en una venue (datos de Foursquare)


Animalito
========

Tiene un nombre generado, reminiscente del japonés.

Puede hacer bond con un Player. Aunque el bonding debería iniciarse siempre desde el lado del Player, esto solo lo hace mutuo.

Una vez "bondeado", puede estar atado (leashed) o no al Player. Esto se usa a efectos de poder irse a vagar solo.

Pude moverse a una Location. Si está bondeado y atado a un player, se moverá automática a la Location a la que se mueva el player. No puede moverse por sí mismo si está atado.

Rutas y Viajes
=========

Un Animalito, una vez desatado, puede emprender viajes independientes. Esto se hace creando una Ruta. La Ruta es una colección de Locations, calculadas a partir de la Location actual, y generadas de acuerdo a una Estrategia. La Estrategia determina la posición de las Locations y el orden en que se recorreran. Actualmente hay tres Estrategias disponibles: linear (puntos en linea recta a partir de la posición actual), random in bbox (puntos esparcidos al azar en una caja de un área determinada alrededor de la posición actual), y clockwise_in_bbox (lo mismo que antes, pero con los puntos ordenados en el sentido de las agujas del relog)

Una vez generada una Ruta, el Animalito empieza un Journey, recorriendo los puntos en el orden establecido en la Ruta. El viaje puede ser instantaneo (en velocidad "de ordenador") o podemos recurrir a un concepto que llamo "natural time" (como opuesto a real time): si especificamos una velocidad para el viaje, en km/h, el Animalito se demorará en el "trayecto" entre cada punto los segundos que tardaría en recorrer la distancia entre ambos puntos a velocidad especificada. Por tanto, si dos puntos están separados 10 kilómetros, y hemos especificado una velocidad de 10 km/h, tardará una hora en completar ese tramo del viaje.

Locations, Positions y Bumps
==========

Una Location es simplemente un punto (latitud, longitud) en el mapa. Cuando un Animalito (o Player) se mueve a una Location, se genera una Position (Location + Quién + Fecha y Hora)

Una Location mantiene una lista de Ocupantes, quién está ahí en ese momento. Si dos Animalitos ocupan la misma Location en un mismo momento, chocan sus cabezas. Llamamos a esto Bump.


Temperament y Joy
==========

Cuando un Animalito nace, se le genera un Temperamento. El temperamento ahora son simplemente tres puntuaciones: "Like", "Dislike" y "Volatile". Estas puntuaciones son números entre 0 y 1, y representan probabilidades. 

Con el Temperament podemos hacer que el Animalito opine ("consider") sobre cosas. Cada cosa sobre la que opina debe expresarse como una URL, que podemos asignar de donde veamos conveniente. Por ejemplo, en vez de hacer [Animalito "opina sobre" [Justin Bieber]], hacemos [Animalito [opina sobre] [http://en.wikipedia.org/wiki/Justin_Bieber]]. Para opinar sobre un sitio en el que el player hace checkin, le pasamos la URL del sitio en Foursquare, etc. 

"Opinar" consiste en lo siguiente. Una vez pasada la cosa (la URL) sobre la que opinar, sacamos un número aleatorio. Si este número es menor que la probabilidad "Like" del Temperamento, entonces le "gustará", asignando un +1. Si el número es mayor, se saca otro aleatorio. Si este segundo aleatorio es menos que la probabilidad "Dislike", la cosa no le gustará, le asignará un -1. Si este segundo aleatorio es mayor que la probabilidad Dislike, la cosa le resultará indiferente, se le asigna un 0.

La opinión del Animalito para la cosa X se guarda, de forma que una vez que ha opinado sobre algo lo recordará de ahí en adelante. SALVO una cosa que explico más adelante.

Ahora que tenemos la opinión del Animalito sobre Justin Bieber (+1/0-1), podemos hacer que lo "disfrute". Para que lo disfrute le pasamos la cosa y un número de puntos. "Disfrutar" implica que a los puntos de felicidad (Joy) que tiene el Animalito (empieza con 100), se le suma el resultado de multipliar la opinión por los puntos. Por ejemplo, si le gusta JB, y los puntos de gustar son 5, entonces su Joy aumentará (100 + (+1*5)) hasta 105. Si JB le disgusta quedará en 95 (100 + (-1*5)). Si es neutral se queda igual.

En el Temperament mencionamos la puntación para Volatile. Esto hace al Animalito un poco caprichoso. Volatile es una p muy baja (< 0.3) de que cada vez que se opine sobre X, se vuelva a opinar aunque ya se tenga una opinión hecha. Es decir, si la puntuación de Volatile es 0.12, cada vez que se opine sobre JB hay un 88% de recuperar la opinión anterior, y ser consistente, y un 12% de probabilidad de volver a opinar, con lo cuál esta vez puede que cambie de opinión (o puede ser que siga igual, claro) Esta nueva opinión caprichosa no se guarda, solo afecta a esta ocasión.

Existe una opción de re-opinar, que hace que se borre la opinión existente sobre algo y se vuelva a calcular. Esto, a diferencia del "capricho", sí queda guardado hasta que se vuelva a re-opinar.

Por el momento, se usa el sistema de Gustos en dos momentos: sobre la Venue de Foursquare en la que entra el usuario y para el tiempo metereológico que hace en cada Location a la que se mueve el Animalito. Otra posibilidad es sacar opinión sobre todas las categorías 4SQ de cada Venue en la que se haga checkin. De esta forma, podemos tener Animalitos a los que les gusten las droguerías y les desagraden los Museos, y al revés.

Una cosa curiosa es que para que opine sobre el tiempo, le pasamos la URL del icono del tiempo que asigna el sitio del que sacamos la información, así que el Animalito opina realmente sobre las URLs 'http://wadus/sunny.jpg', 'http://wadus/cloudy.jpg', etc. 



Luma
==========

Un Animalito tiene un nivel de energía cuantificado en unidades de Luma. Hay acciones, como moverse, que le costarán Luma. Para alimentarse, hay que proporcionarle una imagen, cuanto más luminosa mejor. Se hace un análisis de esta imagen y se calcula su nivel de Luma (p.ej. 78) Cada vez que el Animalito se alimenta de la imagen, este nivel de Luma se suma al suyo. Con cada vez que se alimenta, el nivel de Luma de la imagen se reduce a la mitad, así que puede alimentarse dos veces (34), tres (17), cuatro (8), cinco (4), seis (dos), siete (uno). La octava vez la imagen no tiene puntos de Luma y es inútil.