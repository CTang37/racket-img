#lang racket

(define color-names (list "orangered" "tomato" "darkred" "firebrick" "crimson" "deeppink" "maroon" "indianred" "mediumvioletred" "violetred"
                          "lightcoral" "hotpink" "palevioletred" "lightpink" "rosybrown" "pink" "orchid" "snow" "chocolate"
                          "saddlebrown" "brown" "darkorange" "coral" "sienna" "orange" "salmon" "peru" "darkgoldenrod" "goldenrod"
                          "sandybrown" "lightsalmon" "darksalmon" "gold" "yellow" "olive" "burlywood" "tan" "navajowhite" "peachpuff"
                          "khaki" "darkkhaki" "moccasin" "wheat" "bisque" "palegoldenrod" "blanchedalmond" "mediumgoldenrod" "papayawhip" "mistyrose"
                          "lemonchiffon" "antiquewhite" "cornsilk" "lightgoldenrodyellow" "oldlace" "linen" "lightyellow" "seashell" "beige" "floralwhite"
                          "ivory" "green" "lawngreen" "chartreuse" "greenyellow" "yellowgreen" "mediumforestgreen" "olivedrab" "darkolivegreen" "darkseagreen"
                          "lime" "darkgreen" "limegreen" "forestgreen" "springgreen" "mediumspringgreen" "seagreen" "mediumseagreen" "aquamarine" "lightgreen"
                          "palegreen" "mediumaquamarine" "turquoise" "lightseagreen" "mediumturquoise" "honeydew" "mintcream" "royalblue" "dodgerblue" "deepskyblue"
                          "cornflowerblue" "steelblue" "lightskyblue" "darkturquoise" "cyan" "aqua" "darkcyan" "teal" "skyblue" "cadetblue"
                          "darkslategray" "lightslategray" "slategray" "lightsteelblue" "lightblue" "powderblue" "paleturquoise" "lightcyan" "aliceblue" "azure"
                          "mediumblue" "darkblue" "midnightblue" "navy" "blue" "indigo" "blueviolet" "mediumslateblue" "slateblue" "purple"
                          "darkslateblue" "darkviolet" "darkorchid" "mediumpurple" "mediumorchid" "magenta" "fuchsia" "darkmagenta" "violet" "plum"
                          "thistle" "ghostwhite" "white" "whitesmoke" "gainsboro" "lightgray" "silver" "gray" "darkgray"
                          "dimgray" "black" "transparent" "lightbrown" "mediumbrown" "darkbrown" "mediumcyan" "lightgoldenrod" "mediumgray"
                          "mediumgreen" "lightorange" "mediumorange" "mediumpink" "darkpink"  "lightpurple" "darkpurple" "lightred" "mediumred" "lightturquoise"
                          "mediumyellow" "darkyellow"))

(provide color-names)