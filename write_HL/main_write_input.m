%% Write input files for hydrolight runs into 20 HL folders

%% Specify input variables
% Specify nruns and divide among 20 folders
nruns = 20; % Specify number of runs

% Specify ranges for IOPs
mmG = [0 0.01];
mmX =  [0 0.001];
mmdepth = [0 0]; % [0 0] for deep water, positive numbers for shallow, must be >0.1
mmS = [0.01 0.02];
mmY = [0 1.2];

% Specify backsacttering ratio bbp/bp (in decimal, not percentage)
bacr = 0.018;

% Specify water type
wt_type = 'deep';

%% Commence writing
% Separate into 20 folders
nfpf = ceil(nruns/20);
rem = nruns - (nfpf*19);

for ifol = 1:20
    % Folder name
    folname = ['..\run_HE\' 'HE' num2str(ifol)];
    % Create runlist file
    rl_fid = fopen([folname '\run\runlist.txt'],'wt','n','US-ASCII');

    % Call writing function
    if strcmp(wt_type,'shallow') == 1
        % Create filelist file
        fl_fid = fopen([folname '\data\botmrefl\filelist.txt'],'w','n','US-ASCII');
        write_shallow(rl_fid,fl_fid,ifol,folname,nfpf,rem,mmG,mmX,mmdepth,bacr)
        fclose(fl_fid);
        
    elseif strcmp(wt_type,'deep') == 1
        write_deep(rl_fid,ifol,folname,nfpf,rem,mmG,mmX,mmS,mmY,bacr)
        
    end
    
    fclose(rl_fid);

    
    clearvars rl_fid fl_fid
end

