function out = readDroot(file)

%readDroot
%
%   out = readDroot(file)
%
%   file is a string containing the filename of the Hydrolight v 5 full
%   digital output Droot.txt.  file is presumed to be in the current
%   working matlab directory.  If Droot.txt is in a different directory,
%   then file should include the full path.
%
%   out is a structure containing the parameters of interest.  In its
%   current form, out has the following parameters (and dimensions):
%
%     out.fmu    : quad-center mu values (1-D)
%     out.phi    : quad-center phi values (1-D)
%     out.z      : geometric depths of output (1-D)
%     out.wb     : wavelength band-center values (1-D)
%     out.RADMa  : spectral diffuse upward radiances in air, i.e.,
%                  water-leaving radiances (3-D)
%     out.RAD0Ma : spectral direct upward radiances in air, i.e.,
%                  surface-reflected sky radiances (3-D)
%     out.RAD0Pa : spectral direct downward radiances in air, i.e.,
%                  incident sky radiances (3-D)
%     out.Ed     : spectral downwelling plane irradiance, in air and in
%                  water (2-D)
%     out.RADMz  : spectral diffuse upward radiances in water (4-D)
%     out.RADPz  : spectral diffuse downward radiances in water (4-D)
%     out.RAD0Pz : spectral direct downward radiances in water (4-D)
%
%   1-D parameters are simply lists.
%   For 2-D parameters, dimension 1 corresponds to depth, and dimension 2
%      corresponds to wavelength.
%   For 3-D parameters, dimension 1 corresponds to phi, dimension 2
%      corresponds to mu, and dimension 3 corresponds to wavelength.
%   For 4-D parameters, dimension 1 corresponds to depth, dimension 2
%      corresponds to phi, dimension 3 corresponds to mu, and dimension 4
%      corresponds to wavelength.
%
%   This version written by Eric J. Hochberg, 19 March 2010

fid = fopen(file,'r');
a = fread(fid,inf,'*char');
fclose(fid);
a = a';

% get fmu

s0 = 'fmu (quad-center mu values)';
s1 = 'phi (quad-center phi values)';

fmu = getconstant(a,s0,s1);
nmu = length(fmu);

% get phi

s0 = 'phi (quad-center phi values)';
s1 = 'zeta (optical depths of output)';

phi = getconstant(a,s0,s1);
nphi = length(phi);

% get z

s0 = 'z (geometric depths of output)';
s1 = 'bndmu (quad boundary mu values)';

z = getconstant(a,s0,s1);
nz = length(z);

% get wavelengths

s0 = 'wave (wavelength band-center values)';
s1 = 'waveb (wavelength band-boundary values)';

wb = getconstant(a,s0,s1);
wb = wb(:)';
nwave = length(wb);

% get RADMa

s0 = 'RADMa (diffuse upward radiances in air (water-leaving radiances))';
s1 = 'RADMz (diffuse upward radiances in water)';

RADMa = getspectral_dir_a(a,s0,s1,nphi,nmu,nwave);

% get RAD0Ma

s0 = 'RAD0Ma (direct upward radiances in air (surface-reflected sky radiance))';
s1 = 'RAD0Pa (direct downward radiances in air (incident sky radiances))';

RAD0Ma = getspectral_dir_a(a,s0,s1,nphi,nmu,nwave);

% get RAD0Pa

s0 = 'RAD0Pa (direct downward radiances in air (incident sky radiances))';
s1 = 'RAD0Pz (direct downward radiances in water)';

RAD0Pa = getspectral_dir_a(a,s0,s1,nphi,nmu,nwave);

% get Eu

s0 = 'Eu (upwelling plane irradiance)';
s1 = 'Ed (downwelling plane irradiance)';

Eu = getspectral_z(a,s0,s1,nz,nwave);

% get Ed

s0 = 'Ed (downwelling plane irradiance)';
s1 = 'fMUu (upwelling average cosine)';

Ed = getspectral_z(a,s0,s1,nz,nwave);

% get radsky

s0 = 'radsky (total incident sky radiance)';
s1 = 'HYDROLIGHT Run Title:';

radsky = getspectral_dir_a_radsky(a,s0,s1,nphi,nmu,nwave);

% get upwelling average cosine

s0 = 'fMUu (upwelling average cosine)';
s1 = 'fMUd (downwelling average cosine)';

fMUu = getspectral_z(a,s0,s1,nz,nwave);

% get downwelling average cosine

s0 = 'fMUd (downwelling average cosine)';
s1 = 'fMUtot (total average cosine)';

fMUd = getspectral_z(a,s0,s1,nz,nwave);

% get total average cosine

s0 = 'fMUtot (total average cosine)';
s1 = 'R (irradiance reflectance)';

fMUtot = getspectral_z(a,s0,s1,nz,nwave);

% get RADMz

s0 = 'RADMz (diffuse upward radiances in water)';
s1 = 'RADPa (diffuse downward radiances in air (identically zero))';

RADMz = getspectral_dir_z(a,s0,s1,nz,nphi,nmu,nwave);

% get RADPz

s0 = 'RADPz (diffuse downward radiances in water)';
s1 = 'RAD0Ma (direct upward radiances in air (surface-reflected sky radiance))';

RADPz = getspectral_dir_z(a,s0,s1,nz,nphi,nmu,nwave);

% get RAD0Pz

s0 = 'RAD0Pz (direct downward radiances in water)';
s1 = 'radsky (total incident sky radiance)';

RAD0Pz = getspectral_dir_z(a,s0,s1,nz,nphi,nmu,nwave);


% set outputs
out.fmu = fmu;
out.phi = phi;
out.z = z;
out.wb = wb;
out.RADMa = RADMa;
out.RAD0Ma = RAD0Ma;
out.RAD0Pa = RAD0Pa;
out.Eu = Eu;
out.Ed = Ed;
out.RADMz = RADMz;
out.RADPz = RADPz;
out.RAD0Pz = RAD0Pz;
out.radsky = radsky;

function value = getconstant(a,s0,s1)

% This subfunction parses constants, i.e., parameters that do not vary with
% wavelength or depth and are not quad-averaged.  This would be useful for
% imisc, fmisc, fmu, phi, zeta, z, bdnmu, bdnphi, omega, wave, and waveb.

i0 = findstr(a,s0);
i1 = findstr(a,s1);
i0 = i0 + length(s0) + 2;
i1 = i1 - 1;

i0 = i0(1);
i1 = i1(1);

q = a(i0:i1);
q = double(q);
i = find(q ~= 10 & q ~= 13);
q = q(i);
q = char(q);

value = str2num(q);
value = value(:);


function value = getspectral_z(a,s0,s1,nz,nwave)

% This subfunction parses parameters that vary with wavelength and with
% depth, but are not quad-averaged values (i.e., not radiances).  This
% would be useful for the various acoefs, bcoefs, and bbcoefs, as well as
% atten, albedo, Eou, Eod, Eu, Ed, fMUu, fMUd, fMUtot, and R.

i0 = findstr(a,s0);
i1 = findstr(a,s1);
i0 = i0 + length(s0) + 2;
i1 = i1 - 1;

value = zeros(nz+1,nwave);

for k = 1:length(i0)
   q = a(i0(k):i1(k));
   q = double(q);
   i = find(q ~= 10 & q ~= 13);
   q = char(q(i));
   q = str2num(q);
   value(:,k) = q(:);
end


function value = getspectral_dir_a(a,s0,s1,nphi,nmu,nwave)

% This subfunction parses parameters that are quad-averaged (i.e.,
% radiances) and that vary with wavelength, but are in the air (i.e., do
% not vary with depth).  This would be useful for RADMa, RADPa, RAD0Ma,
% RAD0Pa, and radsky.

i0 = findstr(a,s0);
i1 = findstr(a,s1);
i0 = i0 + length(s0) + 2;
i1 = i1 - 1;

value = zeros(nphi,nmu,nwave);

for k = 1:length(i0)
   q = a(i0(k):i1(k));
   value(:,:,k) = str2num(q);
end

function value = getspectral_dir_a_radsky(a,s0,s1,nphi,nmu,nwave)

% This subfunction parses parameters that are quad-averaged (i.e.,
% radiances) and that vary with wavelength, but are in the air (i.e., do
% not vary with depth).  This would be useful for RADMa, RADPa, RAD0Ma,
% RAD0Pa, and radsky.

i0 = findstr(a,s0);
i1 = findstr(a,s1);
i1(1) = [];
sz = size(i1,2);
i1(sz+1) = size(a,2);
i0 = i0 + length(s0) + 2;
i1 = i1 - 1;

value = zeros(nphi,nmu,nwave);

for k = 1:length(i0)
   q = a(i0(k):i1(k));
   value(:,:,k) = str2num(q);
end

function value = getspectral_dir_z(a,s0,s1,nz,nphi,nmu,nwave)

% This subfunction parses parameters that quad-averaged (i.e., radiances),
% that vary with wavelength, and that vary with depth.  This would be
% useful for RADMz, RADPz, and RAD0Pz.

i0 = findstr(a,s0);
i1 = findstr(a,s1);
i0 = i0 + length(s0) + 2;
i1 = i1 - 1;

value = zeros(nz,nphi,nmu,nwave);

for k = 1:length(i0)
   q = a(i0(k):i1(k));
   v = str2num(q);
   j0 = 1:nphi:size(v,1);
   j1 = nphi:nphi:size(v,1);
   for j = 1:nz
      value(j,:,:,k) = v(j0(j):j1(j),:);
   end
end
