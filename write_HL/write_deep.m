% fprintf function for writing input and br files
% Writes for one folder

function write_deep(rl_fid,ifol,folname,nfpf,rem,mmG,mmX,mmS,mmY,bacr)
% Starting run number
srun = (ifol - 1)*nfpf + 1;
% Set number of runs to make
nrun = ifol*nfpf;
if ifol == 20
    nrun = (ifol - 1)*nfpf + rem;
end

%% Begin iteration
% for irun = 1:nruns
for irun = srun:nrun
    %% Generate random input values and input file
    % Generate CDOM, ag(440) between 0 and 2
    ag440 = (mmG(2) - mmG(1))*rand + mmG(1);
    % Generate bbp(550) between 0 and 1
    bbp550 = (mmX(2) - mmX(1))*rand + mmX(1);
    pcon = bbp550/bacr; % particle concentration with 1.8% backscatter
    % Generate S value for CDOM absorption
    S = (mmS(2) - mmS(1))*rand + mmS(1);
    % Generate Y value for particle scattering
    Y = (mmY(2) - mmY(1))*rand + mmY(1);
    
    % Unique file number (ag440, bbp550, depth, sand pc)
    filenum = strcat(num2str(ag440,'%.3f'),'_',num2str(bbp550,'%.3f'),'_',num2str(S,'%.3f'),'_',num2str(Y,'%.1f'));

    % Create input file
    fn = strcat('deep_',num2str(irun),'_',filenum);
    fdir = [folname '\run\batch\' 'I' fn '.txt'];
    in_fid = fopen(fdir,'w','n','US-ASCII');
    
    %% Write entry in runlist
    fprintf(rl_fid,'%s\n',strcat('I',fn,'.txt'));
    
    %% Commence writing input file
    % Default Parameters
    fprintf(in_fid,'%i%s %i%s %i%s %.2f%s %i%s %.5f%s %i%s %.1f\n',...
        0,',',400,',',700,',',0.02,',',488,',',0.00026,',',1,',',5.3);
    
    % Run title and rootname
    fprintf(in_fid,'%s\n',fn);
    fprintf(in_fid,'%s\n',fn);
    
    % Output options
    fprintf(in_fid,'%i%s%i%s%i%s%i%s%i%s%i\n',...
        -1,',',1,',',0,',',0,',',0,',',1);
    
    % Model options
    fprintf(in_fid,'%i%s%i%s%i%s%i%s%i\n',...
        2,',',1,',',0,',',2,',',3);
    
    % no comps, no concs
    fprintf(in_fid,'%i%s%i\n',...
        4,',',4);
    
    % component concentrations
    fprintf(in_fid,'%.2f%s %.2f%s %.2f%s %.2f\n',...
        0,',',0,',',ag440,',',pcon);
    
    % Specific absorption parameters & file names
    fprintf(in_fid,'%i%s %i%s %i%s %.2f%s %.3f\n',... % Pure water absorption
        0,',',1,',',440,',',0.1,',',0.014);
    fprintf(in_fid,'%i%s %i%s %i%s %.2f%s %.3f\n',... % Chl absorption
        0,',',3,',',440,',',0.1,',',0.014);
    fprintf(in_fid,'%i%s %i%s %i%s %.2f%s %.3f\n',... % CDOM absorption
        0,',',4,',',440,',',1,',',S);
    fprintf(in_fid,'%i%s %i%s %i%s %.2f%s %.3f\n',... % Particle absorption
        0,',',6,',',0,',',0,',',0);
    fprintf(in_fid,'%s\n','..\data\H2OabDefaults_SEAwater.txt');
    fprintf(in_fid,'%s\n','..\data\defaults\astarchl.txt');
    fprintf(in_fid,'%s\n','dummyastar.txt');
    fprintf(in_fid,'%s\n','adummy.txt');
    
    % Specific scattering parameters & file names
    fprintf(in_fid,'%i%s %i%s %.2f%s %i%s %.2f%s %i\n',...
        0,',',-999,',',-999,',',-999,',',-999,',',-999);
    fprintf(in_fid,'%i%s %i%s %.2f%s %i%s %.2f%s %i\n',...
        1,',',550,',',0.3,',',1,',',0.62,',',-999);
    fprintf(in_fid,'%i%s %i%s %.2f%s %i%s %.2f%s %i\n',...
        -1,',',-999,',',0,',',-999,',',-999,',',-999);
    fprintf(in_fid,'%i%s %i%s %.2f%s %.1f%s %.2f%s %i\n',...
        1,',',550,',',1,',',Y,',',1,',',-999);
    fprintf(in_fid,'%s\n','bstarDummy.txt');
    fprintf(in_fid,'%s\n','dummybstar.txt');
    fprintf(in_fid,'%s\n','dummybstar.txt');
    fprintf(in_fid,'%s\n','..\data\defaults\bstarmin_average.txt');
    
    % Type of concentrations and phase functions
    fprintf(in_fid,'%i%s %.3f%s %i%s %.2f%s %i\n',...
        0,',',0,',',550,',',0.01,',',0);
    fprintf(in_fid,'%i%s %.3f%s %i%s %.2f%s %i\n',...
        3,',',0,',',550,',',0.01,',',0);
    fprintf(in_fid,'%i%s %.3f%s %i%s %.2f%s %i\n',...
        -1,',',0,',',0,',',0,',',0);
    fprintf(in_fid,'%i%s %.3f%s %i%s %.2f%s %i\n',...
        1,',',bacr,',',550,',',0.01,',',0); % bbp/bb ratio is 2nd value
    fprintf(in_fid,'%s\n','pureh2o.dpf');
    fprintf(in_fid,'%s\n','Case1Small.dpf');
    fprintf(in_fid,'%s\n','isotrop.dpf');
    fprintf(in_fid,'%s\n','avgpart.dpf');
    
    % no of wavelengths & wavelengths
    wave = (395:10:855)';
    nwave = size(wave,1);
    wave_str = strcat(num2str(wave(1)),',');
    
    for iw = 2:nwave
        temp_wave = strcat(num2str(wave(iw)),',');
        wave_str = [wave_str ' ' temp_wave];
    end
    
    fprintf(in_fid,'%i\n',nwave-1);
    fprintf(in_fid,'%s\n',wave_str);
    
    % Inelastic scattering & internal sources
    fprintf(in_fid,'%i%s%i%s%i%s%i%s%i\n',...
        0,',',0,',',0,',',0,',',2);
    
    % Sky model options
    fprintf(in_fid,'%i%s %i%s %i%s %i%s %i\n',...
        2,',',3,',',60,',',0,',',0);
    
    % Atmospheric Conditions
    fprintf(in_fid,'%i%s %.2f%s %.2f%s %.2f%s %i%s %i%s %.1f%s %i%s %.5f%s %i\n',...
        -1,',',1.29,',',103.85,',',29.92,',',1,',',80,',',2.5,',',15,',',0,',',300);
    
    % Surface information
    fprintf(in_fid,'%.5f%s %.2f%s %.1f%s %.1f\n',...
        0,',',1.34,',',25.0,',',35.0);
    
    % Bottom reflectance options
    fprintf(in_fid,'%i%s %.2f\n',...
        0,',',0);
    
    fprintf(in_fid,'%i%s %i%s %i%s %.2f%s \n',0,',',2,',',0,',',10,',');

    % Data files
    fprintf(in_fid,'%s\n',...
        '..\data\H2OabDefaults_SEAwater.txt');
    fprintf(in_fid,'%i\n',...
        1);
    fprintf(in_fid,'%s\n',...
        'dummyAC9data.txt');
    fprintf(in_fid,'%s\n',...
        'dummyFilteredAc9.txt');
    fprintf(in_fid,'%s\n',...
        'dummyHscat.txt');
    fprintf(in_fid,'%s\n',...
        'dummyComp.txt');
    fprintf(in_fid,'%s\n',...
        'dummyComp.txt');
    fprintf(in_fid,'%s\n',...
        'avg_ooid_sand.txt'); % bottom reflectance type
    fprintf(in_fid,'%s\n',...
        'dummydata.txt');
    fprintf(in_fid,'%s\n',...
        'dummyComp.txt');
    fprintf(in_fid,'%s\n',...
        'dummyComp.txt');
    fprintf(in_fid,'%s\n',...
        'dummyComp.txt');
    fprintf(in_fid,'%s\n',...
        'DummyIrrad.txt');
    fprintf(in_fid,'%s\n',...
        '..\data\MyBiolumData.txt');
    
    fclose(in_fid);
end

end