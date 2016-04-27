warning('off', 'MATLAB:ClassInstanceExists');
clear classes % ! super important ! if you don't do this, MATLAB won't reload your classes

% best parameters so far...
% KEEP I_WM equal for both task and feature units

%{
params = 
  [WM units focal, low emph ...
   WM units focal, high emph ...
   WM units nonfocal, low emph ...
   WM units nonfocal, high emph ...
   WM bias,
   WM bias];
where
  WM units = [
    OG Task     PM Task     OG features     Monitor tortoise    Monitor tor
  ];
%}

startpar = [1  0       1    0, ...      % focal, low emph
            1  0       1    0.7, ...    % focal, high emph
            1  0.4   0.7    0.5, ...    % nonfocal, low emph
            1  0.6   0.6    0.5, ...    % nonfocal, high emph
            3 3];
        
[data, extra] = EM2005(startpar, 5);

filename = sprintf('/mnt/cd/people/mtomov/data/%s.mat', mfilename());
save('exp5-data-new.mat', '-v7.3');