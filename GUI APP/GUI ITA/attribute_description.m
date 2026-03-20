%% Create string array with attribute description
% 
%

clear all
clc
close all

N_attr = 3;
ABT = string(zeros(N_attr,2))

%
% From "A Sound Wheel for Reproduced Sound" [pedersen2015]
%
% loudness description (From ANSI:
% https://en.wikipedia.org/wiki/Loudness#cite_note-1)
str_loudness = "Quell’attributo della sensazione uditiva secondo il quale i suoni possono essere ordinati in una scala che si estende da silenzioso a rumoroso.";

% attack description
str_attack = "Transient response. Specifies wheter the drum beats and percussion, etc. are accurate and clear i.e. if you can hear the actual strokes from drumstick, the plucking of the strings etc. it is also espressed as the ability to reproduce each audio source transient cleanly and separated from the rest of the sound image. Imprecise Attack is understood as unclear or a muted impact";

% treble description
str_treble = "Treble or High frequency extension";
str_treble = str_treble + "\n" + "- A little: As if you hear music through a door, muffled, blurred or dull"
str_treble = str_treble + "\n" + "- A lot: Crystal-clear reproduction extended treble range with airy and open treble. Lightness,purity and clarity with space for instruments. Clarity in the upper frequencies without being sharp or shrill and without distortion"
str_treble = compose(str_treble)  % 1-by-1 string containing every lines of text

% bass-depth description
str_bassdepth = "Denotes how far the bass extends downwards. If it goes down in the low end of the spectrum, there is great depth. Should not be confused with Bass strength, which indicates the strength of the bass or Boomy which related to resonances in the lower bass region"

% Timbral balance description
str_darkbright = "Denota il bilanciamento tra bassi e alti."
str_darkbright = str_darkbright + "\n" + "- Scuro: Bassi eccessivi. Sia bassi troppo forti che alti deboli."
str_darkbright = str_darkbright + "\n" + "- Neutrale: Bassi e Alti sono percepiti con lo stesso volume, c’è un bilanciamento nella riproduzione. Ciò vale anche se sia i bassi che gli alti sono ugualmente deboli o se i bassi e gli alti sono entrambi troppo forti. Se questo porta a delle frequenze medie leggere o marcate, questo viene valutato dalla forza della gamma media."
str_darkbright = str_darkbright + "\n" + "- Chiaro: Alti eccessivi. Sia alti troppo forti che bassi deboli."
str_darkbright = str_darkbright + "\n" + "La causa per cui il suono può essere scuro o chiaro può essere dedotta dalla valutazione dell’intensità dei bassi o dell’intensità degli alti"
str_darkbright = compose(str_darkbright)

% preference test description (From MUSHRA test example [ITU2003RBS1534])
str_preference = "Valuta gli stimuli in base alla scala di qualità continua (CQS)"

str_name = ["LOUDNESS","BILANCIAMENTO TIMBRICO","PREFERENZA"]
str_descr = [str_loudness, str_darkbright, str_preference]

for ii=1:N_attr
            ABT(ii,1)= str_name(ii)
            ABT(ii,2)= str_descr(ii)
end


save('attributes_and_description','ABT')







