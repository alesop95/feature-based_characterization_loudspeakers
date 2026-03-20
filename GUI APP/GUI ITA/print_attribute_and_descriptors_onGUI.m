function [] = print_attribute_and_descriptors_onGUI(handles)

                                   %
                                    %
                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SAME FOR EVERY LISTENER AS EVERYTHING IS ENCODED IN handles.row  
                                     %
                                    %
                                   %


                                   
%%%%%%%%%%% FINO A 120 STAMPO GLI ATTRIBUTES E LA DESCRIPTION NORMALMENTE

if handles.count <= handles.tot_attr*handles.tot_speakers*handles.tot_tracks

% CASO ATTRIBUTO 1 
index_1 = zeros(1,(handles.tot_attr*handles.tot_speakers*handles.tot_subj/handles.tot_attr));
for ii=(handles.tot_attr - 2):handles.tot_attr:(handles.tot_attr*handles.tot_speakers*handles.tot_tracks - 2)
index_1 (ii)= ii;
end
index_1 = nonzeros(index_1)';

% PRINT ATTRIBUTE 1
if any(handles.a(1,index_1) == handles.row(handles.count))
set(handles.attribute, 'String',handles.abt(1,1));
set(handles.description, 'String',handles.abt(1,2));
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%
% CASO ATTRIBUTO 2
index_2 = zeros(1,(handles.tot_attr*handles.tot_speakers*handles.tot_subj/handles.tot_attr));
for ii=(handles.tot_attr - 1):handles.tot_attr:(handles.tot_attr*handles.tot_speakers*handles.tot_tracks - 1)
index_2 (ii)= ii
end
index_2 = nonzeros(index_2)';

% PRINT ATTRIBUTE 2
if any(handles.a(1,index_2) == handles.row(handles.count))
set(handles.attribute, 'String',handles.abt(2,1));
set(handles.description, 'String',handles.abt(2,2));
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%
% CASO ATTRIBUTO 3
index_3 = zeros(1,(handles.tot_attr*handles.tot_speakers*handles.tot_subj/handles.tot_attr));
for ii=(handles.tot_attr - 0):handles.tot_attr:(handles.tot_attr*handles.tot_speakers*handles.tot_tracks - 0)
index_3 (ii)= ii
end
index_3 = nonzeros(index_3)';

% PRINT ATTRIBUTE 3
if any(handles.a(1,index_3) == handles.row(handles.count))
set(handles.attribute, 'String',handles.abt(3,1));
set(handles.description, 'String',handles.abt(3,2));
end 

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ALTRIMENTI L'ULTIMA VOLTA CHE PREMO IL BOTTONE NEXT
if handles.count == handles.tot_attr*handles.tot_speakers*handles.tot_tracks + 1
    set(handles.attribute, 'String',"Congratulazioni!  Il test è finito!");
    set(handles.description, 'String',"Congratulazioni! Il test è finito!");
end

