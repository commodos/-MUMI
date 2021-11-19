function varargout = ms(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%

%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 19-Feb-2020 08:55:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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

% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);
Position=get(gcf,'Position');
Position(3)=240;
set(gcf,'Position',Position);

[a,map]=imread('icons/generate.png');
[r,c,d]=size(a); 
x=ceil(r/30); 
y=ceil(c/30); 
g=a(1:x:end,1:y:end,:);
g(g==255)=5.5*255;
set(handles.calculate,'CData',g);

[a,map,alpha]=imread('icons/settings.png');
[r,c,d]=size(a); 
x=ceil(r/30); 
y=ceil(c/30); 
g=a(1:x:end,1:y:end,:);
g(g==255)=5.5*255;
set(handles.btnAdvanced,'CData',g);


try    
    Test_settings;   
    if isfield(Test,'N') set(handles.intN,'String',Test.N); end
    if isfield(Test,'fs') set(handles.intFs,'String',Test.fs); end
    if isfield(Test,'fmin') set(handles.intFmin,'String',Test.fmin); end
    if isfield(Test,'fmax') set(handles.intFmax,'String',Test.fmax); end
    if isfield(Test,'NInputchannels') set(handles.Nchannels,'Value',Test.NInputchannels); end
    if isfield(Test,'CFoptimization') set(handles.chkCFoptimization,'Value',Test.CFoptimization); end
    if isfield(Test,'enforcefminfmax') set(handles.chkEnforce,'Value',Test.enforcefminfmax); end
    if isfield(Test,'plot') set(handles.chkPlotOpt,'Value',Test.plot); end
    if isfield(Test,'NormalizeToRMS') set(handles.strRMSmode,'Value',2-Test.NormalizeToRMS); end
    if isfield(Test,'NormalizationValue') set(handles.intRMS,'String',Test.NormalizationValue); end 
    if isfield(Test,'Mode') 
        switch  upper(Test.Mode)
            case 'FAST'
                setDefaultFast(handles);
                set(handles.btnFast,'Value',1);
                set(handles.btnCombined,'Value',0);
                set(handles.btnRobust,'Value',0);
                set(handles.btnCustum,'Value',0);    
            case 'ROBUST'
                setDefaultRobust(handles);
                set(handles.btnFast,'Value',0);
                set(handles.btnCombined,'Value',0);
                set(handles.btnRobust,'Value',1);
                set(handles.btnCustum,'Value',0);    
            otherwise
                setDefaultCombined(handles);
                set(handles.btnFast,'Value',0);
                set(handles.btnCombined,'Value',1);
                set(handles.btnRobust,'Value',0);
                set(handles.btnCustum,'Value',0);  
        end
    end
    calculateTime(handles);
end
        

% end
% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
% hObject    handle to calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global u;
options=[];


options.N = str2double(get(handles.intN,'String'));
options.fs = str2double(get(handles.intFs,'String'));
options.fmin = str2double(get(handles.intFmin,'String'));
options.fmax = str2double(get(handles.intFmax,'String'));
options.vectorizedOutput=1;
options.NInputchannels=get(handles.Nchannels,'Value');
options.P = str2double(get(handles.intP,'String'));
options.M = str2double(get(handles.intM,'String'));
options.R = options.NInputchannels*options.M;
options.tau = str2double(get(handles.intTau,'String'));
options.CFoptimization=get(handles.chkCFoptimization,'Value');
options.plot=get(handles.chkPlotOpt,'Value');
options.enforcefminfmax=get(handles.chkEnforce,'Value');

value=get(handles.intFgroup,'String');
options.Fgroup=str2double(value(get(handles.intFgroup,'Value')));

if (get(handles.strRMSmode,'Value') == 1)
    options.rms=str2double(get(handles.intRMS,'String'));
else
    options.maxAmplitude=str2double(get(handles.intRMS,'String'));
end

if (get(handles.strStructure,'Value') == 3)
    options.channel_mode=-1;
end
if (get(handles.strStructure,'Value') == 4)
    options.channel_mode=0;
end
if (get(handles.strStructure,'Value') == 1)
    options.channel_mode=1;
end
if (get(handles.strStructure,'Value') == 2)
    options.channel_mode=2;
end

switch get(handles.strPhaseType,'Value')
    case 1
        options.phaseType='random';
    case 2
        options.phaseType='linear';
    case 3
        options.phaseType='schroeder';
end

if (get(handles.harmonicsOdd,'Value') == 1 || get(handles.harmonicsOddRandom,'Value') == 1 ||  get(handles.harmonicsOddMissing,'Value') == 1)
    options.onlyOdd=1;
end

if (get(handles.harmonicsOddRandom,'Value') == 1)
    options.missingHarmonics='random';
end

if (get(handles.harmonicsOddMissing,'Value') == 1)
    obj=get(handles.intMissingHarmonics,'String');
    options.missingHarmonics=str2double(obj(get(handles.intMissingHarmonics,'Value')));
end

f0 = options.fs/options.N;
lines = 1:floor(options.N/2);

switch get(handles.strMagnitude,'Value')    
    case 2, [~, ~, options.gain_on_lines] = generateDecadeBand(options.fmin,options.fmax, str2double(get(handles.intMagnitude,'String')),f0,lines)
    case 3, [~, ~, options.gain_on_lines] = generateOctaveBand(options.fmin,options.fmax, str2double(get(handles.intMagnitude,'String')),f0,lines)
%     case 3, set(handles.txtMagnitude,'visible','off'); set(handles.intMagnitude,'visible','on'); 
    case 4, 
        try
            options.gain_on_lines=evalin('base',get(handles.intMagnitude,'String'));
            if length(options.gain_on_lines)~=floor(options.N/2)
                warndlg('Workspace variable has an incompatible size');
                return
            end
        catch
            warndlg('Unexpected error');
            return;
        end
end


%  options.maxAmplitude = 1; %
options.u=GenerateSignal(options);
% LMS_ExcitationSignals(filename,u,options.fs)

workspacevariable = get(handles.strWorkspace, 'String');
if isempty(workspacevariable) 
else
  assignin('base',workspacevariable,options)
end

filename = get(handles.strMatlab, 'String');

if ~isempty(filename) 
    if ispc
        Matlabfilename= strcat('Drives\',filename);
        if contains(pwd,'\SAMI')  
            Matlabfilename=strcat('multisine\',Matlabfilename);
        elseif ~contains(pwd,'\multisine')  
            Matlabfilename=strcat('..\multisine\',Matlabfilename);
        end
        try
            save(strcat(sprintf('%s.mat',Matlabfilename)),'options');
        catch
            save(sprintf('%s.mat',filename),'options');
        end    
    else
        Matlabfilename= strcat('Drives/',Matlabfilename)
        if contains(pwd,'/SAMI')  
            Matlabfilename=strcat('multisine/',Matlabfilename);
        elseif ~contains(pwd,'/multisine')  
            Matlabfilename=strcat('../multisine/',Matlabfilename);
        end    
        try
            save(strcat(sprintf('%s.mat',Matlabfilename)),'options');      
        catch
            save(sprintf('%s.mat',filename),'options');
        end    
    end
end



% --- Executes when selected object changed in methodgroup.
function methodgroup_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in methodgroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (hObject == handles.btnFast)
    setDefaultFast(handles);
    set(handles.btnCombined,'Value',0);
    set(handles.btnRobust,'Value',0);
    set(handles.btnCustum,'Value',0);    
elseif (hObject == handles.btnRobust)
    setDefaultRobust(handles);
    set(handles.btnCombined,'Value',0);
    set(handles.btnFast,'Value',0);
    set(handles.btnCustum,'Value',0);    
elseif (hObject == handles.btnCustum)
    setDefaultCustom(handles);
    set(handles.btnCombined,'Value',0);
    set(handles.btnFast,'Value',0);
    set(handles.btnRobust,'Value',0);
else
    setDefaultCombined(handles);
    set(handles.btnFast,'Value',0);
    set(handles.btnRobust,'Value',0);
    set(handles.btnCustum,'Value',0);
end
groupHarmonics_SelectionChangedFcn(hObject, eventdata, handles)

% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
if isfield(handles, 'measurementData') && ~isreset
    return;
end
warning off
try
 if ispc addpath('..\sources'); else addpath('../sources'); end
end
try addpath('sources'); end
warning on
setDefaultValues(handles);
setDefaultCombined(handles)
calculateTime(handles) 
guidata(handles.figure1, handles);


function setDefaultValues(handles)
set(handles.intN,'String','1024');
set(handles.intP,'String',8);
set(handles.intM,'String',1);
set(handles.intFs,'String',1024);
set(handles.intFmin,'String',1);
set(handles.intFmax,'String',400);

function setDefaultFast(handles)
set(handles.harmonicsOddRandom,'Value',1);
set(handles.intM,'Enable','off');
set(handles.harmonicsAll,'Enable','off');
set(handles.harmonicsOdd,'Enable','on');
set(handles.harmonicsOddMissing,'Enable','on');
set(handles.harmonicsOddRandom,'Enable','on');
set(handles.strPhaseType,'Enable','on');
set(handles.strPhaseType,'Value',1);
set(handles.intTau,'String','1');
set(handles.intM,'String',1);
set(handles.intP,'String',8);

try  
    Test_settings;   
    set(handles.intP,'String',Test.Fast.P);
    set(handles.intM,'String',Test.Fast.M);
end


function setDefaultRobust(handles)
set(handles.harmonicsAll,'Value',1);
set(handles.harmonicsAll,'Enable','on');
set(handles.harmonicsOdd,'Enable','off')
set(handles.harmonicsOddRandom,'Enable','off')
set(handles.harmonicsOddMissing,'Enable','off')
% set(handles.strPhaseType,'Enable','on');
set(handles.intM,'Enable','on');
set(handles.intM,'String',8);
set(handles.intP,'String',3);
set(handles.strPhaseType,'Enable','off');
set(handles.strPhaseType,'Value',1);
set(handles.intTau,'Visible','off');
set(handles.txtTau,'visible','off')
set(handles.txtS,'visible','off')
try  
    Test_settings;   
    set(handles.intP,'String',Test.Robust.P);
    set(handles.intM,'String',Test.Robust.M);
end


function setDefaultCustom(handles)
set(handles.harmonicsAll,'Value',1);
set(handles.harmonicsAll,'Enable','on');
set(handles.harmonicsOdd,'Enable','on')
set(handles.harmonicsOddRandom,'Enable','on')
set(handles.harmonicsOddMissing,'Enable','on')
set(handles.strPhaseType,'Enable','on');
set(handles.intM,'Enable','on');
set(handles.intM,'String',8);
set(handles.intP,'String',3);
set(handles.strPhaseType,'Enable','on');
set(handles.strPhaseType,'Value',1);
set(handles.intTau,'Visible','off');
set(handles.txtTau,'visible','off')
set(handles.txtS,'visible','off')


function setDefaultCombined(handles)
set(handles.harmonicsOddRandom,'Value',1);
set(handles.harmonicsAll,'Enable','off');
set(handles.harmonicsOdd,'Enable','on')
set(handles.harmonicsOddRandom,'Enable','on')
set(handles.harmonicsOddMissing,'Enable','on')
% set(handles.strPhaseType,'Enable','on');
set(handles.intM,'Enable','on')
set(handles.intP,'String',3);
set(handles.intM,'String',8);

try  
    Test_settings;   
    set(handles.intP,'String',Test.Combined.P);
    set(handles.intM,'String',Test.Combined.M);
end

% --- Executes during object creation, after setting all properties.
function intFmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intFmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function intFmax_Callback(hObject, eventdata, handles)
% hObject    handle to intFmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if(str2double(get(hObject,'String'))<str2double(get(handles.intFmin,'String')))
        warndlg(sprintf('fmax cannot be smaller than fmin'))
        set(handles.intFmax,'String',str2double(get(handles.intFs,'String'))/2*0.8);
    end
    
    if(str2double(get(hObject,'String'))>str2double(get(handles.intFs,'String'))/2)
        warndlg(sprintf('fmax cannot be greater than fs/2'))
        set(handles.intFmax,'String',str2double(get(handles.intFs,'String'))/2*0.8);
    end
    


function intFmin_Callback(hObject, eventdata, handles)
% hObject    handle to intFmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    if(str2double(get(hObject,'String'))>str2double(get(handles.intFmax,'String')))
        warndlg(sprintf('fmin cannot be greater than fmax'))
        set(handles.intFmin,'String',str2double(get(handles.intFs,'String'))/str2double(get(handles.intN,'String')));
    end


% --- Executes during object creation, after setting all properties.
function intFmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intFmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in radiobutton24.
function radiobutton24_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton24


% --- Executes on button press in btnFast.
function btnFast_Callback(hObject, eventdata, handles)
% hObject    handle to btnFast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of btnFast
methodgroup_SelectionChangeFcn(hObject, eventdata, handles) 
calculateTime(handles) 

% --- Executes on button press in btnRobust.
function btnRobust_Callback(hObject, eventdata, handles)
% hObject    handle to btnRobust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of btnRobust
methodgroup_SelectionChangeFcn(hObject, eventdata, handles)
calculateTime(handles) 

function calculateTime(handles) 
    
    N = str2double(get(handles.intN,'String'));
    fs = str2double(get(handles.intFs,'String'));
    P = str2double(get(handles.intP,'String'));
    M = str2double(get(handles.intM,'String'));
    Ninput = get(handles.Nchannels,'Value');
    time=N/fs*P*M*Ninput;
    fres=fs/N;
    set(handles.txtTime,'String', sprintf('Signal length: %.2f sec',time));
    set(handles.txtReal,'String', sprintf('Total realizations: %i, total blocks: %i',Ninput*M,Ninput*M*P));
    
    set(handles.txtFreq,'String', sprintf('Frequency resolution: %.2f Hz',fres));
    
    if (get(handles.harmonicsOdd,'Value') == 1)
        set(handles.txtFreqEff,'String', sprintf('Effective frequency resolution: %.2f Hz',fres/2));
    elseif get(handles.harmonicsOddRandom,'Value') == 1 ||  get(handles.harmonicsOddMissing,'Value') == 1
        Fg=get(handles.intFgroup,'String'); Fg(get(handles.intFgroup,'Value'));
        Fg=str2double(Fg(get(handles.intFgroup,'Value')));
        set(handles.txtFreqEff,'String', sprintf('Effective resolution: %.2f Hz',fres/2*((Fg-1)/(Fg))));
    else
        set(handles.txtFreqEff,'String', sprintf('Effective resolution: %.2f Hz',fres));
    end
    


function intN_Callback(hObject, eventdata, handles)
% hObject    handle to intN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of intN as text
%        str2double(get(hObject,'String')) returns contents of intN as a double
calculateTime(handles) 

% --- Executes during object creation, after setting all properties.
function intN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function intP_Callback(hObject, eventdata, handles)
% hObject    handle to intP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of intP as text
%        str2double(get(hObject,'String')) returns contents of intP as a double
calculateTime(handles) 

% --- Executes during object creation, after setting all properties.
function intP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function intM_Callback(hObject, eventdata, handles)
% hObject    handle to intM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of intM as text
%        str2double(get(hObject,'String')) returns contents of intM as a double
calculateTime(handles) 

% --- Executes during object creation, after setting all properties.
function intM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function intFs_Callback(hObject, eventdata, handles)
% hObject    handle to intFs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of intFs as text
%        str2double(get(hObject,'String')) returns contents of intFs as a double
    if(str2double(get(hObject,'String'))<2*str2double(get(handles.intFmax,'String'))*0.8)
        set(handles.intFmax,'String',(str2double(get(hObject,'String'))/2*0.8));
    end
    if(str2double(get(handles.intFmax,'String'))<str2double(get(handles.intFmin,'String')))
       set(handles.intFmin,'String',str2double(get(handles.intFs,'String'))/str2double(get(handles.intN,'String')));
    end
    calculateTime(handles) 

% --- Executes during object creation, after setting all properties.
function intFs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intFs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes when selected object is changed in groupHarmonics.
function groupHarmonics_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in groupHarmonics 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (get(handles.harmonicsOddMissing,'Value') == 1)
    set(handles.intMissingHarmonics,'visible','on')    
    set(handles.intFgroup,'visible','on')    
    set(handles.txtFgroup,'visible','on')     
    set(handles.chkEnforce,'visible','on')    
elseif (get(handles.harmonicsOddRandom,'Value') == 1)
    set(handles.intMissingHarmonics,'visible','off')    
    set(handles.intFgroup,'visible','on')    
    set(handles.txtFgroup,'visible','on')     
    set(handles.chkEnforce,'visible','on')    
else        
    set(handles.intMissingHarmonics,'visible','off')
    set(handles.intFgroup,'visible','off')    
    set(handles.txtFgroup,'visible','off')        
    set(handles.intMissingHarmonics,'visible','off')    
    set(handles.chkEnforce,'visible','off')    
end
calculateTime(handles) 

% --- Executes on selection change in intMissingHarmonics.
function intMissingHarmonics_Callback(hObject, eventdata, handles)
% hObject    handle to intMissingHarmonics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns intMissingHarmonics contents as cell array
%        contents{get(hObject,'Value')} returns selected item from intMissingHarmonics


% --- Executes during object creation, after setting all properties.
function intMissingHarmonics_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intMissingHarmonics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chkPlotOpt.
function chkPlotOpt_Callback(hObject, eventdata, handles)
% hObject    handle to chkPlotOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkPlotOpt


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4



function strTestLab_Callback(hObject, eventdata, handles)
% hObject    handle to strTestLab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of strTestLab as text
%        str2double(get(hObject,'String')) returns contents of strTestLab as a double


% --- Executes during object creation, after setting all properties.
function strTestLab_CreateFcn(hObject, eventdata, handles)
% hObject    handle to strTestLab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function strWorkspace_Callback(hObject, eventdata, handles)
% hObject    handle to strWorkspace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of strWorkspace as text
%        str2double(get(hObject,'String')) returns contents of strWorkspace as a double


% --- Executes during object creation, after setting all properties.
function strWorkspace_CreateFcn(hObject, eventdata, handles)
% hObject    handle to strWorkspace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chkCFoptimization.
function chkCFoptimization_Callback(hObject, eventdata, handles)
% hObject    handle to chkCFoptimization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkCFoptimization


% --- Executes on selection change in strPhaseType.
function strPhaseType_Callback(hObject, eventdata, handles)
% hObject    handle to strPhaseType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns strPhaseType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from strPhaseType

if (get(handles.strPhaseType,'Value') == 1)
    set(handles.chkCFoptimization,'Enable','on')
else    
    set(handles.chkCFoptimization,'Enable','off')
    set(handles.chkCFoptimization,'Value',0)
end


if (get(handles.strPhaseType,'Value') == 2)
    set(handles.intTau,'visible','on')
    set(handles.txtTau,'visible','on')
    set(handles.txtS,'visible','on')
else    
    set(handles.intTau,'visible','off')
    set(handles.txtTau,'visible','off')
    set(handles.txtS,'visible','off')
end


% --- Executes during object creation, after setting all properties.
function strPhaseType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to strPhaseType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function intTau_Callback(hObject, eventdata, handles)
% hObject    handle to intTau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of intTau as text
%        str2double(get(hObject,'String')) returns contents of intTau as a double


% --- Executes during object creation, after setting all properties.
function intTau_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intTau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnAdvanced.
function btnAdvanced_Callback(hObject, eventdata, handles)
% hObject    handle to btnAdvanced (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of btnAdvanced

    groupHarmonics_SelectionChangedFcn(hObject, eventdata, handles);
    
    if(get(hObject,'Value'))
        Position=get(gcf,'Position');
        Position(3)=550;
        set(handles.btnCustum,'visible','on')        
        set(gcf,'Position',Position);
    else
        Position=get(gcf,'Position');
        Position(3)=240;
        set(gcf,'Position',Position);        
        set(handles.btnCustum,'visible','off')
    end


% --- Executes on selection change in intFgroup.
function intFgroup_Callback(hObject, eventdata, handles)
% hObject    handle to intFgroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns intFgroup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from intFgroup


% --- Executes during object creation, after setting all properties.
function intFgroup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intFgroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit35_Callback(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit35 as text
%        str2double(get(hObject,'String')) returns contents of edit35 as a double


% --- Executes during object creation, after setting all properties.
function edit35_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Nchannels.
function Nchannels_Callback(hObject, eventdata, handles)
% hObject    handle to Nchannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Nchannels contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Nchannels
calculateTime(handles) 

% --- Executes during object creation, after setting all properties.
function Nchannels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nchannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in strStructure.
function strStructure_Callback(hObject, eventdata, handles)
% hObject    handle to strStructure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns strStructure contents as cell array
%        contents{get(hObject,'Value')} returns selected item from strStructure


% --- Executes during object creation, after setting all properties.
function strStructure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to strStructure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in strRMSmode.
function strRMSmode_Callback(hObject, eventdata, handles)
% hObject    handle to strRMSmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns strRMSmode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from strRMSmode


% --- Executes during object creation, after setting all properties.
function strRMSmode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to strRMSmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function intRMS_Callback(hObject, eventdata, handles)
% hObject    handle to intRMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of intRMS as text
%        str2double(get(hObject,'String')) returns contents of intRMS as a double


% --- Executes during object creation, after setting all properties.
function intRMS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intRMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnCombined.
function btnCombined_Callback(hObject, eventdata, handles)
% hObject    handle to btnCombined (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of btnCombined
methodgroup_SelectionChangeFcn(hObject, eventdata, handles)
calculateTime(handles) 


% --- Executes on button press in btnCustum.
function btnCustum_Callback(hObject, eventdata, handles)
% hObject    handle to btnCustum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of btnCustum
methodgroup_SelectionChangeFcn(hObject, eventdata, handles)
calculateTime(handles) 


% --- Executes on selection change in strMagnitude.
function strMagnitude_Callback(hObject, eventdata, handles)
% hObject    handle to strMagnitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns strMagnitude contents as cell array
%        contents{get(hObject,'Value')} returns selected item from strMagnitude
switch get(hObject,'Value')
    case 1, set(handles.txtMagnitude,'visible','off'); set(handles.intMagnitude,'visible','off'); 
    case 2, set(handles.txtMagnitude,'visible','off'); set(handles.intMagnitude,'visible','on'); 
    case 3, set(handles.txtMagnitude,'visible','off'); set(handles.intMagnitude,'visible','on'); 
    case 4, set(handles.txtMagnitude,'visible','on'); set(handles.intMagnitude,'visible','on'); 
end
% --- Executes during object creation, after setting all properties.
function strMagnitude_CreateFcn(hObject, eventdata, handles)
% hObject    handle to strMagnitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function intMagnitude_Callback(hObject, eventdata, handles)
% hObject    handle to intMagnitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of intMagnitude as text
%        str2double(get(hObject,'String')) returns contents of intMagnitude as a double


% --- Executes during object creation, after setting all properties.
function intMagnitude_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intMagnitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function strMatlab_Callback(hObject, eventdata, handles)
% hObject    handle to strMatlab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of strMatlab as text
%        str2double(get(hObject,'String')) returns contents of strMatlab as a double


% --- Executes during object creation, after setting all properties.
function strMatlab_CreateFcn(hObject, eventdata, handles)
% hObject    handle to strMatlab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chkEnforce.
function chkEnforce_Callback(hObject, eventdata, handles)
% hObject    handle to chkEnforce (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkEnforce
