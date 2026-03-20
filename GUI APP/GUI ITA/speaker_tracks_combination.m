function [] = speaker_tracks_combination(soggetto, base, count,udp,tot_attr,tot_tracks,tot_speakers,tot_subj,track_period,next)

%
% SAFETY DISABLING PRESSING "NEXT" THE LAST TIME AND LOSE THE RESULTS
%if count == tot_attr*tot_speakers*tot_tracks
%set(next,'Enable','off')
%end
%
%

% HANDLE ALL THE LOGISTIC ACCORDING TO THE MATRIX 
% Devo attivare la sequenza giusta di speaker che è data semplicemente dal numero 
% handles.row è la riga che contiene una volta scelto il soggetto tutte le stringhe
% faccio un confronto con il template 
%
% PER L'ALTERNANZA DELLE TRACCE SEMPLICEMENTE MUTA ALTERNATIVAMENTE QUELLE TRACCE
% Lo schema implicito di sottofondo per cui vengono messi quei numeri è la handles.row riga corrente! 
% L'utilizzo di circshift è per tenere la stessa identica struttura di codice per ognuno dei 15 ascoltatori sulle condizioni dell'if all'interno del case specifico 
% ---> In questa maniera, i primi TRENTA sono sempre quelli che utilizzano LO SPEAKER 1, poi gli altri sei sono quelli che utilizzano LO SPEAKER 2 ecc... 
%
% CHANNEL = SPEAKER 
%
%  % play(player);   ---> meglio Example: player_one.play()  ecc...
%                                % (playet_ith è un oggetto!)
% pause(player);
% resume(player);
% stop(player);
%
%
%           ACCORDING TO THE LISTENER PERFORMING (which is an input)
% soggetto 1  --> shift = 1-1 = 0
% 	        base = circshift(base, 0); 
% soggetto 2  --> shift = 9-1 = 8
% 	        base = circshift(base, 8);
% soggetto 3  --> shift = 17-1 = 16
% 	        base = circshift(base, 16);  %17a riga 16esimo shift 
% (...)
%
% soggetto 14 --> shift = 105-1  = 104
% 		base = circshift(base, 112);  %105a riga 104esimo shift 
%
% soggetto 15 --> shift = 113-1  = 112
% 		base = circshift(base, 112);  %113a riga 112esimo shift 
% 
% 
% ------> quindi è semplicemente:
% shift = 8*(soggetto-1);
% base = circshift(base, shift);
% 
% se soggetto == 1 ---> shift = 0
%    soggetto == 2 ---> shift = 8
% 	(...)


    if soggetto <= 6
shift = 2*(soggetto-1);
base = circshift(base, shift);
    elseif soggetto >= 7
   shift = 2*(soggetto-1)+3;
base = circshift(base, shift);
    end
    


%%%%%%%%%%%%%%%%% QUANDO SUONO TRACCIA 1
if any(count == base((1):(tot_attr))) || any(count == base((1 + track_period):(tot_attr + track_period))) || any(count == base((1 + track_period*2):(tot_attr + track_period*2))) || any(count == base((1 + track_period*3):(tot_attr + track_period*3)))
 
     name = "getlucky.wav"
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% combinazioni speaker traccia 1
 % Make Speaker 1 sound 
if any(count == base((1):(track_period))) 
 oscsend(udp, '/track/1/mute', 'i', 0) 
 oscsend(udp, '/track/2/mute', 'i', 1) 
 oscsend(udp, '/track/3/mute', 'i', 1) 
 oscsend(udp, '/track/4/mute', 'i', 1) 
end
 % Make Speaker 2 sound 
if any(count == base((track_period+1):(track_period*2)))
 oscsend(udp, '/track/1/mute', 'i', 1) 
 oscsend(udp, '/track/2/mute', 'i', 0) 
 oscsend(udp, '/track/3/mute', 'i', 1) 
 oscsend(udp, '/track/4/mute', 'i', 1) 
 end
 % Make Speaker 3 sound 
if any(count == base((track_period*2+1):(track_period*3)))
 oscsend(udp, '/track/1/mute', 'i', 1) 
 oscsend(udp, '/track/2/mute', 'i', 1) 
 oscsend(udp, '/track/3/mute', 'i', 0) 
 oscsend(udp, '/track/4/mute', 'i', 1)   
end
 % Make Speaker 4 sound 
if any(count == base((track_period*3+1):(track_period*4)))
 oscsend(udp, '/track/1/mute', 'i', 1) 
 oscsend(udp, '/track/2/mute', 'i', 1) 
 oscsend(udp, '/track/3/mute', 'i', 1) 
 oscsend(udp, '/track/4/mute', 'i', 0)  
end
 
 playfile(name)

end


%%%%%%%%%%%%%%%%% QUANDO SUONO TRACCIA 2
if any(count == base((1+tot_attr*1):(tot_attr + tot_attr*1))) || any(count == base((1 + track_period + tot_attr*1):(tot_attr + track_period + tot_attr*1))) || any(count == base((1 + track_period*2 + tot_attr*1):(tot_attr + track_period*2  + tot_attr*1))) || any(count == base((1 + track_period*3 + tot_attr*1):(tot_attr + track_period*3 + tot_attr*1)))

     name = "clapton.wav"

     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% combinazioni speaker traccia 2
 % Make Speaker 1 sound 
if any(count == base((1):(track_period))) 
 oscsend(udp, '/track/1/mute', 'i', 0) 
 oscsend(udp, '/track/2/mute', 'i', 1) 
 oscsend(udp, '/track/3/mute', 'i', 1) 
 oscsend(udp, '/track/4/mute', 'i', 1) 
end
 % Make Speaker 2 sound 
if any(count == base((track_period+1):(track_period*2)))
 oscsend(udp, '/track/1/mute', 'i', 1) 
 oscsend(udp, '/track/2/mute', 'i', 0) 
 oscsend(udp, '/track/3/mute', 'i', 1) 
 oscsend(udp, '/track/4/mute', 'i', 1) 
 end
 % Make Speaker 3 sound 
if any(count == base((track_period*2+1):(track_period*3)))
 oscsend(udp, '/track/1/mute', 'i', 1) 
 oscsend(udp, '/track/2/mute', 'i', 1) 
 oscsend(udp, '/track/3/mute', 'i', 0) 
 oscsend(udp, '/track/4/mute', 'i', 1)   
end
 % Make Speaker 4 sound 
if any(count == base((track_period*3+1):(track_period*4)))
 oscsend(udp, '/track/1/mute', 'i', 1) 
 oscsend(udp, '/track/2/mute', 'i', 1) 
 oscsend(udp, '/track/3/mute', 'i', 1) 
 oscsend(udp, '/track/4/mute', 'i', 0)  
end
 
      playfile(name)

end

%%%%%%%%%%%%%%%%% QUANDO SUONO TRACCIA 3
if any(count == base((1+tot_attr*2):(tot_attr + tot_attr*2))) || any(count == base((1 + track_period + tot_attr*2):(tot_attr + track_period + tot_attr*2))) || any(count == base((1 + track_period*2 + tot_attr*2):(tot_attr + track_period*2  + tot_attr*2))) || any(count == base((1 + track_period*3 + tot_attr*2):(tot_attr + track_period*3 + tot_attr*2)))

     name = "sunrise.wav"
     
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% combinazioni speaker traccia 3
 % Make Speaker 1 sound 
if any(count == base((1):(track_period))) 
 oscsend(udp, '/track/1/mute', 'i', 0) 
 oscsend(udp, '/track/2/mute', 'i', 1) 
 oscsend(udp, '/track/3/mute', 'i', 1) 
 oscsend(udp, '/track/4/mute', 'i', 1) 
end
 % Make Speaker 2 sound 
if any(count == base((track_period+1):(track_period*2)))
 oscsend(udp, '/track/1/mute', 'i', 1) 
 oscsend(udp, '/track/2/mute', 'i', 0) 
 oscsend(udp, '/track/3/mute', 'i', 1) 
 oscsend(udp, '/track/4/mute', 'i', 1) 
 end
 % Make Speaker 3 sound 
if any(count == base((track_period*2+1):(track_period*3)))
 oscsend(udp, '/track/1/mute', 'i', 1) 
 oscsend(udp, '/track/2/mute', 'i', 1) 
 oscsend(udp, '/track/3/mute', 'i', 0) 
 oscsend(udp, '/track/4/mute', 'i', 1)   
end
 % Make Speaker 4 sound 
if any(count == base((track_period*3+1):(track_period*4)))
 oscsend(udp, '/track/1/mute', 'i', 1) 
 oscsend(udp, '/track/2/mute', 'i', 1) 
 oscsend(udp, '/track/3/mute', 'i', 1) 
 oscsend(udp, '/track/4/mute', 'i', 0)  
end
 
     playfile(name)

end










% %%%%%%%%%%%%%%%%% QUANDO SUONO TRACCIA 4
% if any(count == base((1+tot_attr*3):(tot_attr + tot_attr*3))) || any(count == base((1 + track_period + tot_attr*3):(tot_attr + track_period + tot_attr*3))) || any(count == base((1 + track_period*2 + tot_attr*3):(tot_attr + track_period*2  + tot_attr*3))) || any(count == base((1 + track_period*3 + tot_attr*3):(tot_attr + track_period*3 + tot_attr*3)))
% 
%          name = "starwars.wav"
%      playfile(name)
%      
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% combinazioni speaker traccia 4
%  % Make Speaker 1 sound 
% if any(count == base((1):(track_period))) 
%  oscsend(udp, '/track/1/mute', 'i', 0) 
%  oscsend(udp, '/track/2/mute', 'i', 1) 
%  oscsend(udp, '/track/3/mute', 'i', 1) 
%  oscsend(udp, '/track/4/mute', 'i', 1) 
% end
%  % Make Speaker 2 sound 
% if any(count == base((track_period+1):(track_period*2)))
%  oscsend(udp, '/track/1/mute', 'i', 1) 
%  oscsend(udp, '/track/2/mute', 'i', 0) 
%  oscsend(udp, '/track/3/mute', 'i', 1) 
%  oscsend(udp, '/track/4/mute', 'i', 1) 
%  end
%  % Make Speaker 3 sound 
% if any(count == base((track_period*2+1):(track_period*3)))
%  oscsend(udp, '/track/1/mute', 'i', 1) 
%  oscsend(udp, '/track/2/mute', 'i', 1) 
%  oscsend(udp, '/track/3/mute', 'i', 0) 
%  oscsend(udp, '/track/4/mute', 'i', 1)   
% end
%  % Make Speaker 4 sound 
% if any(count == base((track_period*3+1):(track_period*4)))
%  oscsend(udp, '/track/1/mute', 'i', 1) 
%  oscsend(udp, '/track/2/mute', 'i', 1) 
%  oscsend(udp, '/track/3/mute', 'i', 1) 
%  oscsend(udp, '/track/4/mute', 'i', 0)  
% end
%  
% 
% end

% %%%%%%%%%%%%%%%%% QUANDO SUONO TRACCIA 5
% if any(count == base((1+tot_attr*4):(tot_attr + tot_attr*4))) || any(count == base((1 + track_period + tot_attr*4):(tot_attr + track_period + tot_attr*4))) || any(count == base((1 + track_period*2 + tot_attr*4):(tot_attr + track_period*2  + tot_attr*4))) || any(count == base((1 + track_period*3 + tot_attr*4):(tot_attr + track_period*3 + tot_attr*4)))
% 
%          name = "taylor.wav"
%      playfile(name)
%      
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% combinazioni speaker traccia 5
% 
%   % Make Speaker 1 sound 
% if any(count == base((1):(track_period))) 
%  oscsend(udp, '/track/1/mute', 'i', 0) 
%  oscsend(udp, '/track/2/mute', 'i', 1) 
%  oscsend(udp, '/track/3/mute', 'i', 1) 
%  oscsend(udp, '/track/4/mute', 'i', 1) 
% end
%  % Make Speaker 2 sound 
% if any(count == base((track_period+1):(track_period*2)))
%  oscsend(udp, '/track/1/mute', 'i', 1) 
%  oscsend(udp, '/track/2/mute', 'i', 0) 
%  oscsend(udp, '/track/3/mute', 'i', 1) 
%  oscsend(udp, '/track/4/mute', 'i', 1) 
%  end
%  % Make Speaker 3 sound 
% if any(count == base((track_period*2+1):(track_period*3)))
%  oscsend(udp, '/track/1/mute', 'i', 1) 
%  oscsend(udp, '/track/2/mute', 'i', 1) 
%  oscsend(udp, '/track/3/mute', 'i', 0) 
%  oscsend(udp, '/track/4/mute', 'i', 1)   
% end
%  % Make Speaker 4 sound 
% if any(count == base((track_period*3+1):(track_period*4)))
%  oscsend(udp, '/track/1/mute', 'i', 1) 
%  oscsend(udp, '/track/2/mute', 'i', 1) 
%  oscsend(udp, '/track/3/mute', 'i', 1) 
%  oscsend(udp, '/track/4/mute', 'i', 0)  
% end
%  
% 
% end
% 


end

