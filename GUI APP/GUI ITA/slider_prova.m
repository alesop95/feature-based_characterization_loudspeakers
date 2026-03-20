%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB GUI FOR PERFORMING LISTENING TEST 
% Alessio Sopranzi - 20/01/2020
%
%
% Implementation: save results for each session in a 15x120 row matrix
% with the name "results_i" where i = 1,2,...,15 is the name of the i-th 
% subject performing the test
%
%
% Caution: "guidata" is a function used to stored data in the GUI (yes, we can store data 
% IN our interface). This means that if the user actually closes the interface, the data is LOST
%
%

function varargout = slider_prova(varargin)
                    % same name of the file 
                    
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @slider_prova_OpeningFcn, ...
                   'gui_OutputFcn',  @slider_prova_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT



%%%%%%%%%%%%%%%%%%%%%%%
%                     %
%   INIZIALIZATIONS   %
%                     %
%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes just before slider_prova is made visible.
function slider_prova_OpeningFcn(hObject, eventdata, handles, varargin)

% 
% %%%% LOAD SONGS
% 
% [one, Fs] = audioread('K04SynBass118C-01.mp3');
% [two, Fs] = audioread('K05Pad126C-01.mp3');
% [three, Fs] = audioread('K06LeadSyn93A-05.mp3');
% [four, Fs] = audioread('K02Drums117-03.mp3');
% [five, Fs] = audioread('pigeons.wav');
% %
% %
% handles.Fs = Fs
% 
%  handles.player_one = audioplayer(one, handles.Fs);
%  handles.player_two = audioplayer(two, handles.Fs);
%  handles.player_three = audioplayer(three, handles.Fs);
%  handles.player_four = audioplayer(four, handles.Fs);
%  handles.player_five = audioplayer(five, handles.Fs);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Remember to pass the
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% object as input to the
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% function


% PARAMETERS
handles.tot_attr = 3
handles.tot_tracks = 3
handles.tot_speakers = 4
handles.tot_subj = 15

%%%% To handle reproduction
handles.BASE = (1:handles.tot_attr*handles.tot_speakers*handles.tot_tracks)         
handles.shift = 0              % Just inizialization to store variable in the GUI structure
handles.track_period = handles.tot_attr * handles.tot_tracks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


global semaforo;
semaforo = 0;


% LET USER INPUT ITS NUMBER (OF SESSION)
x = zeros(1)
x = str2double(input('Enter subject number: ', 's'));
%only to check in the workspace the number of subject entered
assignin('base','x',x)
while isnan(x) || fix(x) ~= x || x>15
  x = str2double(input('Value entered is not valid, please enter an INTEGER or a number < 15: ', 's'));
end

% INITIALIZE ROW OF RESULTS 
handles.results = string(zeros(1,handles.tot_attr*handles.tot_speakers*handles.tot_tracks))  % 0.5s ARE BASICALLY MISSING VALUES!

% LOAD STUFF FROM WORKSPACE
load('lookuptable_string.mat') % Loading lookup table ALREADY SAMPLED
load('attributes_and_description.mat') % Loading attributes and descriptors


%
% DIRECTLY GENERATE THE CELL ARRAY WITH LABELS AND PUT IN THE GUI STRUCTURE
    C = {["Troppo leggero","|","Troppo forte"],["Scuro","Neutrale","Chiaro"],...            sprintf('%s\n%s', "Neither like", "nor dislike");
    ["Non piace estremamente","Non piace molto","Non piace moderatamente","Non piace leggermente","Nè piace nè non piace","Piace leggermente","Piace moderatamente","Piace molto","Piace estremamente"]}
    handles.anchors = C;
%
%

handles.count = 0;      % Global inizialization for counter for lookup table
handles.abt = ABT; %evalin('base', 'ABT');
handles.a = A_sampled;%evalin('base', 'A');
handles.subject = x;%evalin('base', 'x');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SELECT SESSION 
% Lo switch case per far leggere su una diversa riga di A a seconda della
% sessione (soggetto) è stato fatto sopra. Ora ho praticamente la codifica
% pronta gia pseudo-randomizzata per come è fatta la matrice di stringhe
%
% handles.row E' QUELLA CORRENTE A SECONDA DEL SOGGETTO
latinsquare_row = string(zeros (1,size(A_sampled,2)));
latinsquare_row = handles.a(handles.subject,:);
handles.row = latinsquare_row;


% OPEN UDP CONNECTION ON A CERTAIN PORT ON localhost IP
% If already exist a connection in that port, do nothing!
if exist('u','var')
    % Do nothing
else  %Otherwise open it!
    u = udp('127.0.0.1',8000);  
    fopen(u);
end

handles.u = u;                                          % save "u" (UDP object) on the structure
handles.output = hObject;                               % Choose default command line output for slider_prova
guidata(hObject, handles);                              % Update handles structure


% --- Outputs from this function are returned to the command line.
function varargout = slider_prova_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


function slider_editText_Callback(hObject, eventdata, handles)

sliderValue = get(handles.slider_editText,'String');            %get the string for the editText component
sliderValue = str2num(sliderValue);                             %convert from string to number if possible, otherwise returns empty

% Is user inputs something is not a number, or if the input <0
% or >10 (maximum in this case), then the slider value defaults to 0
if (isempty(sliderValue) || sliderValue<0 || sliderValue>10)
    set(handles.slider1,'Value',0);
    set(handles.slider_editText,'String','0');
else
    set(handles.slider1,'Value',sliderValue);
end


% --- Executes during object creation, after setting all properties.
function slider_editText_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%%%%%%%%%%%%%
%   %%      % 
%   %%      %
%   %%      %
%   %%      %
%%%%%%%%%%%%%
% --- EXECUTES ON SLIDER MOVEMENT ---
function slider1_Callback(hObject, eventdata, handles)

sliderValue = get(handles.slider1,'Value');                 %obtain the slider value from the slider component
set(handles.slider_editText,'String',num2str(sliderValue)); %puts slider value into edit text component in the global data %structure
guidata(hObject, handles);                                  %update handles structure

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%
%%%
%%%% PLAY BUTTON
%%%
%
function play_button_Callback(hObject, eventdata, handles)

% FOR SAFETY, DO NOTHING IF WE PRESS "PLAY" AT THE VERY BEGINNING OF THE
% INTERFACE
if handles.count >= 1   % Otherwise do nothing there's nothing to play for the moment :)
global semaforo;
    if semaforo == 1
        semaforo = 0;
    end
speaker_tracks_combination(handles.subject,handles.BASE, handles.count,handles.u,handles.tot_attr,handles.tot_tracks,handles.tot_speakers,handles.tot_subj,handles.track_period,handles.next)

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function attribute_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function attribute_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


           %
           %%%
%%%%%%%%%%%%%%% NEXT(save) BUTTON
           %%%
           %
% --- Executes on button press in NEXT.
function next_Callback(hObject, eventdata, handles)




% PER LE DESCRIZIONI ESATTE DEGLI ATTRIBUTI BASTA VEDERE L'ULTIMA CIFRA DEL SIMBOLO 
% gestione con il count con confronto con handles.row che è la riga della
% codifica a seconda del soggetto corrente 
%
% If count aumenta (each time we press is incremented) 
% -> leggere l'elemento successivo di latinsquare_row 
% che si inizializza in maniera diversa dalla session (ma è tutto gestito prima)
%

% START TO STORE RESULTS ONLY IF WE ARE NOT AT THE BEGINNING 
if handles.count >=1
    % EVERY TIME WE PRESS NEXT WE WANT TO MUTE ALL TRACKS, then according to the matrix
% one only will be unmuted when we press the "PLAY" BUTTON
global semaforo;
   semaforo = 1
 
    % Once press "NEXT" ALSO STORE  result for the attribute in the correspondent point of matrix
    handles.temp = string(get(handles.slider_editText,'String'));
    % A seconda di handles.count riempio la riga del risultato 
    handles.results(handles.count) = handles.temp;
    guidata(hObject,handles)
end


 % UPDATE THE STATE AFTER HAVING SAVED THE CURRENT ATTRIBUTE EVALUATION
handles.count = handles.count + 1;
guidata(hObject, handles);

% PRINT ACCORDINGLY
 print_attribute_and_descriptors_onGUI(handles);
 
 
% RESET SLIDER TO DEFAULT POSITION BEFORE GOING ON
set(handles.slider1,'Value',0.5);
set(handles.slider_editText,'string',0.5);


%%%%%%%%%%%%%%%%%%
%                % 
%   FINAL SAVE   %
%                %
%%%%%%%%%%%%%%%%%%
if handles.count == handles.tot_attr*handles.tot_speakers*handles.tot_tracks + 1
% Store all the results!
    guidata(hObject,handles);
    data = guidata(hObject);
    results = data.results;
    
    % SAVE ACCORDINGLY TO WHICH SUBJECT IS PERFORMING
    filename = [strcat('results_',num2str(handles.subject)),'.mat'];
    save(filename,'results');
    
    % DISABLE NEXT BUTTON
     set(handles.next,'Enable','off')
     
end

% % % % % % % % % % % % 
% % % % % % % % % % % % 
%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
%                      %
%       LABELS         %
%                      %
%%%%%%%%%%%%%%%%%%%%%%%%
%
%

%%%%%  AS THE TEST BEGINS...
if handles.count >=1

%
%
%%%%%%% IF TEST FINISHED EMPTY ALL LABELS INDEPENDENTLY ON THE CURRENT
%%%%%%% (PREVIOUS) ATTRIBUTE 
if handles.count == handles.tot_attr*handles.tot_speakers*handles.tot_tracks+1
        set(handles.label_1, 'String',""); 
        set(handles.label_2, 'String',""); 
        set(handles.label_3, 'String',""); 
        set(handles.label_4, 'String',"");
        set(handles.label_5, 'String',""); 
        set(handles.label_6, 'String',"");  
        set(handles.label_7, 'String',""); 
        set(handles.label_8, 'String',""); 
        set(handles.label_9, 'String',"");
        
else
%
%
% ELSE PRINT CORRECT LABELS 
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LABEL FOR ATTRIBUTE 1
%
%    

    label_1 = zeros(1,(handles.tot_attr*handles.tot_speakers*handles.tot_subj/handles.tot_attr));
    for ii=(handles.tot_attr - 2):handles.tot_attr:(handles.tot_attr*handles.tot_speakers*handles.tot_tracks - 2)
        label_1 (ii)= ii;
    end
    label_1 = nonzeros(label_1)';

  %%%%%%%% PRINT
    if any(handles.a(1,label_1) == handles.row(handles.count))
        set(handles.label_1, 'String',handles.anchors{1,1}(1)); % LEFTMOST LABEL
        set(handles.label_5, 'String',handles.anchors{1,1}(2)); % CENTRAL LABEL
        set(handles.label_9, 'String',handles.anchors{1,1}(3)); % RIGHTMOST LABEL 
    end 


 
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LABEL FOR ATTRIBUTE 2
%
%

    label_2 = zeros(1,(handles.tot_attr*handles.tot_speakers*handles.tot_subj/handles.tot_attr));
    for ii=(handles.tot_attr - 1):handles.tot_attr:(handles.tot_attr*handles.tot_speakers*handles.tot_tracks - 1)
        label_2 (ii)= ii;
    end
    label_2 = nonzeros(label_2)';

  %%%%%%%% PRINT
    if any(handles.a(1,label_2) == handles.row(handles.count))
        set(handles.label_1, 'String',handles.anchors{1,2}(1)); % LEFTMOST LABEL
        set(handles.label_5, 'String',handles.anchors{1,2}(2)); % CENTRAL LABEL
        set(handles.label_9, 'String',handles.anchors{1,2}(3)); % RIGHTMOST LABEL 
    end 

%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LABEL FOR ATTRIBUTE 3
%
%
    
    label_3 = zeros(1,(handles.tot_attr*handles.tot_speakers*handles.tot_subj/handles.tot_attr));
    for ii=(handles.tot_attr - 0):handles.tot_attr:(handles.tot_attr*handles.tot_speakers*handles.tot_tracks - 0)
        label_3 (ii)= ii;
    end
    label_3 = nonzeros(label_3)';
    
    
  %%%%%%%% PRINT
    if any(handles.a(1,label_3) == handles.row(handles.count))
        set(handles.label_1, 'String',handles.anchors{1,3}(1)); % LEFTMOST LABEL
        set(handles.label_5, 'String',handles.anchors{1,3}(5)); % CENTRAL LABEL
        set(handles.label_9, 'String',handles.anchors{1,3}(9)); % RIGHTMOST LABEL
                                                                %
                                                                % CENTRAL LABELS
        set(handles.label_2, 'String',handles.anchors{1,3}(2));
        set(handles.label_3, 'String',handles.anchors{1,3}(3));
        set(handles.label_4, 'String',handles.anchors{1,3}(4));
        set(handles.label_6, 'String',handles.anchors{1,3}(6));
        set(handles.label_7, 'String',handles.anchors{1,3}(7));
        set(handles.label_8, 'String',handles.anchors{1,3}(8));
        
    %IF NOT ATTRIBUTE 6 EMPTY CENTRAL LABELS THAT ARE NOT OVERWRITTEN AS
    %COUNTER GOES ON
    else
        set(handles.label_2, 'String',"");
        set(handles.label_3, 'String',"");
        set(handles.label_4, 'String',"");
        set(handles.label_6, 'String',"");
        set(handles.label_7, 'String',"");
        set(handles.label_8, 'String',"");
    end

  %%%%%%%% PRINT
%     if any(handles.a(1,label_3) == handles.row(handles.count))
%         set(handles.label_1, 'String',handles.anchors{1,3}(1)); % LEFTMOST LABEL
%         set(handles.label_5, 'String',handles.anchors{1,3}(2)); % CENTRAL LABEL
%         set(handles.label_9, 'String',handles.anchors{1,3}(3)); % RIGHTMOST LABEL 
%     end 
    
% %
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LABEL FOR ATTRIBUTE 4
% %
% %
% 
%     label_4 = zeros(1,(handles.tot_attr*handles.tot_speakers*handles.tot_subj/handles.tot_attr));
%     for ii=(handles.tot_attr - 2):handles.tot_attr:(handles.tot_attr*handles.tot_speakers*handles.tot_tracks - 2)
%         label_4 (ii)= ii;
%     end
%     label_4 = nonzeros(label_4)';
% 
%   %%%%%%%% PRINT
%     if any(handles.a(1,label_4) == handles.row(handles.count))
%         set(handles.label_1, 'String',handles.anchors{1,4}(1)); % LEFTMOST LABEL
%         set(handles.label_5, 'String',handles.anchors{1,4}(2)); % CENTRAL LABEL
%         set(handles.label_9, 'String',handles.anchors{1,4}(3)); % RIGHTMOST LABEL 
%     end 
%     
% %
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LABEL FOR ATTRIBUTE 5
% %
% %
%     
%     label_5 = zeros(1,(handles.tot_attr*handles.tot_speakers*handles.tot_subj/handles.tot_attr));
%     for ii=(handles.tot_attr - 1):handles.tot_attr:(handles.tot_attr*handles.tot_speakers*handles.tot_tracks - 1)
%         label_5 (ii)= ii;
%     end
%     label_5 = nonzeros(label_5)';
% 
%   %%%%%%%% PRINT
%     if any(handles.a(1,label_5) == handles.row(handles.count))
%         set(handles.label_1, 'String',handles.anchors{1,5}(1)); % LEFTMOST LABEL
%         set(handles.label_5, 'String',handles.anchors{1,5}(2)); % CENTRAL LABEL
%         set(handles.label_9, 'String',handles.anchors{1,5}(3)); % RIGHTMOST LABEL
%     end 
%     
% %
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LABEL FOR ATTRIBUTE 6
% %
% %
% 
%     index_6 = zeros(1,(handles.tot_attr*handles.tot_speakers*handles.tot_subj/handles.tot_attr));
%     for ii=(handles.tot_attr-0):handles.tot_attr:(handles.tot_attr*handles.tot_speakers*handles.tot_tracks - 0)
%         index_6 (ii)= ii;
%     end
%     index_6 = nonzeros(index_6)';
%     
%   %%%%%%%% PRINT
%     if any(handles.a(1,index_6) == handles.row(handles.count))
%         set(handles.label_1, 'String',handles.anchors{1,6}(1)); % LEFTMOST LABEL
%         set(handles.label_5, 'String',handles.anchors{1,6}(5)); % CENTRAL LABEL
%         set(handles.label_9, 'String',handles.anchors{1,6}(9)); % RIGHTMOST LABEL
%                                                                 %
%                                                                 % CENTRAL LABELS
%         set(handles.label_2, 'String',handles.anchors{1,6}(2));
%         set(handles.label_3, 'String',handles.anchors{1,6}(3));
%         set(handles.label_4, 'String',handles.anchors{1,6}(4));
%         set(handles.label_6, 'String',handles.anchors{1,6}(6));
%         set(handles.label_7, 'String',handles.anchors{1,6}(7));
%         set(handles.label_8, 'String',handles.anchors{1,6}(8));
%         
%     %IF NOT ATTRIBUTE 6 EMPTY CENTRAL LABELS THAT ARE NOT OVERWRITTEN AS
%     %COUNTER GOES ON
%     else
%         set(handles.label_2, 'String',"");
%         set(handles.label_3, 'String',"");
%         set(handles.label_4, 'String',"");
%         set(handles.label_6, 'String',"");
%         set(handles.label_7, 'String',"");
%         set(handles.label_8, 'String',"");
%     end 
% 
%   
end
%
%
end


%
%
% JUST TO LOG VALUES OF THE CURRENT STATE
if handles.count <= handles.tot_attr*handles.tot_speakers*handles.tot_tracks
    disp(handles.count)
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function edit3_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function figure1_DeleteFcn(hObject, eventdata, handles)



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LABEL 1

function label_1_Callback(hObject, eventdata, handles)

function label_1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LABEL 2

function label_2_Callback(hObject, eventdata, handles)

function label_2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LABEL 3

function label_3_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function label_3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LABEL 4

function label_4_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function label_4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LABEL 5

function label_5_Callback(hObject, eventdata, handles)
%
% If attribute 1,2,3,4 --> "|"
% If attribute 5       --> "Neutral"
% If attribute 6       --> "Neither like nor dislike"
% (...)

% --- Executes during object creation, after setting all properties.
function label_5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LABEL 6

function label_6_Callback(hObject, eventdata, handles)

function label_6_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LABEL 7

function label_7_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function label_7_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LABEL 8

function label_8_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function label_8_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LABEL 9

function label_9_Callback(hObject, eventdata, handles)
% If attribute 1,2,3,4,5,6 print correspondent string from handles.abt
% (...)


% --- Executes during object creation, after setting all properties.
function label_9_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
