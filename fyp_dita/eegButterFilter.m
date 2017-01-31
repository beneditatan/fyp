function filteredEEGData = eegButterFilter(EEGData, low, high, order,s)
%
% <The RCSP (Regularized Common Spatial Pattern) Toolbox.>
%     Copyright (C) 2010  Fabien LOTTE
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%band-pass filter a set of EEG signals using a butterworth filter
%
%input params:
%EEGData: extracted EEG signals
%low:low cutoff frequency
%high: high cutoff frequency
%order: filter order
%
%output
%filteredEEGData: the EEG data band-pass filtered in the specified
%   frequency band
%
%by Fabien Lotte (fprlotte@i2r.a-star.edu.sg)
%created: 17/02/2009
%last revised: 17/02/2009



%identifying various constants
nbSamples = size(EEGData,1);
nbChannels = size(EEGData,2);
nbTrials = size(EEGData,3);             %what does this 3 meanss???


%preparing the output data
filteredEEGData = zeros(nbSamples, nbChannels, nbTrials);           %create array of all zero    http://www.mathworks.com/help/matlab/ref/zeros.html 
                                                                    %zeros(2,3) returns a 2-by-3 matrix.
                                                                    %X = zeros(2,3,4);        
% filteredEEGData.c = EEGData.c;                                    %2-by-3-by-4 array of zeros.
% filteredEEGData.s = EEGData.s;
% filteredEEGData.y = EEGData.y;

%designing the butterworth band-pass filter 
lowFreq = low * (2/s);
highFreq = high * (2/s);
[B, A] = butter(order, [lowFreq highFreq]);          %here [B A] any missing comma  - [b, a] same as [b a]



%filtering all channels in this frequency band,                             for the training data
for i=1:nbTrials                %all trials
    for j=1:nbChannels          %all channels
        filteredEEGData(:,j,i) = filter(B,A,EEGData(:,j,i));
    end
end
   