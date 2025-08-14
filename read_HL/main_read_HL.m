%% Mathematical operations on HL data

%% Angles
theta = [87.5 80 70 60 50 40 30 20 10 0];
phi = [0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345];

[X,Y] = meshgrid(theta,phi);


%% Read HL file and calc values
Dfn = 'Dtest2.txt';
Dout = readDroot(Dfn);

% Calculate Rrs
Lu = Dout.RADMa;
Ed = (Dout.Ed(1,:))';
Rrs = Lu./permute(Ed,[2,3,1]); % bsx div
rrs_calc = Rrs./(0.518 + 1.562*Rrs);

% Calculate rrs
lu = squeeze(Dout.RADMz(1,:,:,:));
ed = (Dout.Ed(2,:))';
rrs = lu./permute(ed,[2,3,1]); % bsx div
Rrs_calc = (0.518*rrs)./(1 - 1.562*rrs);

% Calculate sub-surface r
ed = (Dout.Ed(2,:))';
eu = (Dout.Eu(2,:))';
r = eu./ed;

%% Plot
figure
hold on
xlabel('theta')
ylabel('phi')
%% diffuse upwards radiances in water
surf(X,Y,squeeze(Dout.RADMz(1,:,:,28)));

%% diffuse upward radiances in air (water-leaving radiances)
surf(X,Y,squeeze(Dout.RADMa(:,:,28)));

%% direct upwards radiances in air (surface-reflected sky radiance)
surf(X,Y,squeeze(Dout.RAD0Ma(:,:,28)));

%% diffuse downward radiances in water
surf(X,Y,squeeze(Dout.RADPz(1,:,:,28)));

%% direct downward radiances in air (incident sky radiances)
surf(X,Y,squeeze(Dout.RAD0Pa(:,:,28)));

%% direct downward radiances in water
surf(X,Y,squeeze(Dout.RAD0Pz(1,:,:,28)));

%% radsky (total incident sky radiance) - same as RAD0Pa
surf(X,Y,squeeze(Dout.radsky(:,:,28)));

%% rrs
surf(X,Y,rrs(:,:,28));
surf(X,Y,rrs_calc(:,:,28));

%% Rrs
surf(X,Y,Rrs(:,:,28));
surf(X,Y,Rrs_calc(:,:,28));

%% underwater r
plot(Dout.wb,r);
