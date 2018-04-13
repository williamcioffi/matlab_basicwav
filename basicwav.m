% some basic wav manipulation

filename = 'clip3_bp.wav';

info = audioinfo(filename);

% take a look at the information
info

%load the wav
[y, fs] = audioread(filename);

% calculate nyquist
nyq = fs / 2;

% take a look
plot(y);
xlabel('samples');

% make the x axis seconds
x = 1:length(y);
x = x / fs;

plot(x, y);
axis([min(x) max(x) min(y) max(y)])
xlabel('time (seconds)');

% calculate the spectrum

help pwelch

% fft parameters
nfft = 1024;
win = hann(nfft);
adv = nfft * .5;

% use pwelch to calculate the spectrum
[pxx, ff] = pwelch(y, win, adv, nfft, fs); 

% convert to dB
pxx_db = 10*log10(pxx);

% use semilog scale so we can see what is actually happening
semilogx(ff, pxx_db);
xlabel('freq');
ylabel('dB');

% make a spectrogram
help spectrogram


% make a figure with both the wavform and the spectrogram
subplot 211;
plot(x, y);
axis([min(x) max(x) min(y) max(y)])

subplot 212;
spectrogram(y, win, adv, nfft, fs, 'yaxis');
% change to log frequency so we can actually see what is happening.
ax = gca;
ax.YScale = 'log';
colorbar off;

% listen to a clip
bits = info.BitsPerSample;
y_norm = y/max(abs(y));
clipplayer = audioplayer(y_norm(1:10*fs), fs, bits);
clipplayer.play();

% it's too low! listen to it at 10 times speed
clipplayer = audioplayer(y_norm(1:50*fs), fs*10, bits);
clipplayer.play();
figure(1);

% filter the clip
filterfreq = [15, 30];
[b, a] = butter(3, filterfreq/nyq);
yf = filtfilt(b, a, y);

% look at the filtered clip
subplot 211;
plot(x, yf);
axis([min(x) max(x) min(y) max(y)])

subplot 212;
spectrogram(yf, win, adv, nfft, fs, 'yaxis');
ax = gca;
ax.YScale = 'log';
colorbar off;

% play the filtered sound (10 times speed)
yf_norm = yf / max(abs(yf));
clipplayer = audioplayer(yf_norm(1:50*fs), fs*10, bits);
clipplayer.play();