function [] = playfile(nome)

global semaforo;
%%%%%% READ FILES
% Mono
fileReader = dsp.AudioFileReader(nome);
fileInfo = audioinfo(nome)

% Set properties here        ||||
 deviceWriter = audioDeviceWriter('Driver','ASIO','SampleRate',fileInfo.SampleRate);

% Check available devices
devices = getAudioDevices(deviceWriter)


% If deviceWriter is called with one column of data, two channels are 
% written to your audio output device. Both channels correspond to the one column of data
%
%
% %SET THE MAPPING
% release(deviceWriter)
deviceWriter.ChannelMappingSource = 'Property';
deviceWriter.ChannelMapping = 1;

disp("prova " + semaforo)


while ~isDone(fileReader) && semaforo == 0
    
    pause(0.01)
    audioData = fileReader();
    deviceWriter(audioData);
end

release(deviceWriter)
end




