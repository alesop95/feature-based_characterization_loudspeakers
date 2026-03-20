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
str_loudness = "That attribute of auditory sensation in terms of which sounds can be ordered on a scale extending from quiet to loud.";

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
str_darkbright = "Denotes the balance between bass and treble."
str_darkbright = str_darkbright + "\n" + "- Dark: Excessive bass. Either loud bass or weak treble."
str_darkbright = str_darkbright + "\n" + "- Neutral: Bass and treble are perceived equally loud, there is a balance in the reproduction. This also applies if both bass and treble are equally weak or if the bass and treble are both too loud. If it leads to prominent or soft midrange this is assessed by the Midrange strength."
str_darkbright = str_darkbright + "\n" + "- Bright: Excessive treble. Either loud treble or weak bass."
str_darkbright = str_darkbright + "\n" + "The cause for the sound being dark or light can be deduced from the assessments of Bass strength and Treble strength"
str_darkbright = compose(str_darkbright)

% preference test description (From MUSHRA test example [ITU2003RBS1534])
str_preference = "Score the stimuli according to the continuous quality scale (CQS)"

str_name = ["LOUDNESS","TIMBRAL BALANCE","PREFERENCE"]
str_descr = [str_loudness, str_darkbright, str_preference]

for ii=1:N_attr
            ABT(ii,1)= str_name(ii)
            ABT(ii,2)= str_descr(ii)
end


save('attributes_and_description','ABT')







