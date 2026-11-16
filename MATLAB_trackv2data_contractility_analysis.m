close all;
% Parameters
start_analysis =1;
end_analysis = 420;
data = data(start_analysis:end_analysis, :);
num_pairs = 3;  % Numbers of paired points
num_rows = size(data, 1); % Numbers of rows
fps = 1; % Number of frames per seconds recorded --> 1 or 0.5 for U46 to U51 (+U42+ U43+ U49) (+U69 (substack))
time_step = 1 / fps;
time_total = num_rows * time_step; % in seconds
time_total_min = time_total /60; % in minutes
e = 48.33; % Conversion pixel/mm U42 = 67.5722716, U43 = 50.15285714, U44= 44.28571429 U47 = 44.8051, 
% U48 = 44.46, U49 = 48.81192857, U50 = 42.91, U52 = 45.1658 , U53 = 46.13, U54 = 39.45729182, U55 = 43.63,
% U56 = , U57 = 42.22, U58 = 44.48, U59 = 48.33,  U61 = 81.5554, U69 = 64.09, U75 = 51.14
sigma = 3; % Écart-type pour imgaussfilt (fixe)
minpeak =1; % A ajuster en fonction 
minpeakSerosa = 1; % A ajuster en fonction
minpeakMid =1.2; % A ajuster en fonction
offset_percent = 40; % espacement courbes plot final amplitude
% Enregistrement données
folder_path = 'C:\Users\Emilie\Documents\Contractility\analyses trackv2\Oxytocin_T0_T7';
file_name = 'Bath_trackv2_U59_after_drugs_S3_t0_t7_v2.mat';


% Préparation des indices pour les colonnes x et y
x_indices = 1:4:(4 * num_pairs - 3); % Colonnes x
y_indices = 2:4:(4 * num_pairs - 2);     % Colonnes y

% Extraction des distances
distances = zeros(num_rows, num_pairs); % Matrice des distances

% Calcul distances
for i = 1:num_pairs
    % Coordonnées des points d'une paire
    x_coords = data(:, x_indices(i));
    y_coords = data(:, y_indices(i));
    x_coords_next = data(:, x_indices(i) + 2); % Coordonnées x du point suivant
    y_coords_next = data(:, y_indices(i) + 2); % Coordonnées y du point suivant

    % Calcul des distances entre les deux points d'une paire
    distances(:, i) = sqrt((x_coords_next - x_coords).^2 + (y_coords_next - y_coords).^2);
end

% Calcul distance (mm)
distances_mm = distances / e;

% Temps
time_vector = (0:num_rows-1) * time_step;

% Courbes distances
figure;
hold on;
for i = 1:num_pairs
    plot(time_vector, distances(:, i), 'DisplayName', ['Paire ' num2str(i)]);
end
xlabel('Temps (s)');
ylabel('Distance ( en pixel)');
title('Distances en pixel entre les paires de points au cours du temps');
legend show;
grid on;
hold off;

% Calcul lissage distances(avec imgaussfilt)
smoothed_distances = zeros(size(distances)); % Initialisation

for i = 1:num_pairs
    smoothed_distances(:, i) = imgaussfilt(distances(:, i), sigma);
end

% Figure courbes distances en mm lissées
figure;
hold on;
for i = 1:num_pairs
    plot(time_vector, smoothed_distances(:, i), 'DisplayName', ['Paire ' num2str(i)]);
end
xlabel('Temps (s)');
ylabel('Distance');
title('Distances lissées (gaussfilt) entre les paires de points au cours du temps');
legend show;
grid on;
hold off;

% Calcul lissage distances en mm (avec imgaussfilt)
smoothed_distances_mm = zeros(size(distances_mm)); % Initialisation

for i = 1:num_pairs
    smoothed_distances_mm(:, i) = imgaussfilt(distances_mm(:, i), sigma);
end
for i = 1:num_pairs
    smoothed_distances_mm(:, i) = imgaussfilt(distances_mm(:, i), sigma);
end

% Figure courbes distances en mm lissées
figure;
hold on;
for i = 1:num_pairs
    plot(time_vector, smoothed_distances_mm(:, i), 'DisplayName', ['Paire ' num2str(i)]);
end
xlabel('Temps (s)');
ylabel('Distance (en mm)');
title('Distances lissées en mm (gaussfilt) entre les paires de points au cours du temps');
legend show;
grid on;
hold off;

% Calcul du strain (pixel) basé sur la distance maximale
strain = zeros(num_rows - 1, num_pairs);
for i = 1:num_pairs
    
    % Find baseline for each pair
    baseline = mean(movmax(distances(:, i), 200));
    
    % Calculate strain par rapport à baseline
    strain(:, i) = ((distances(2:end, i) - baseline) ./ baseline) * 100; % Distance relative à la baseline
end

% Calcul lissage strain (avec imgaussfilt)
smoothed_strain = zeros(size(strain)); % Initialisation

for i = 1:num_pairs
    smoothed_strain(:, i) = imgaussfilt(strain(:, i), sigma);
    smoothed_strain(:,i) = - smoothed_strain(:,i);
end

% Initialisation des structures pour stocker les pics et prominences
peaks = cell(1, num_pairs);
locations = cell(1, num_pairs);
prominences = cell(1, num_pairs);
peak_data = cell(1, num_pairs);
frequency = zeros(1, num_pairs); % mean frequency per pairs
amplitude_table = zeros(1, num_pairs);
width_data = {};



% Offset des courbes : Paire 1 (haut), Paire 2 (milieu), Paire 3 (bas)
offsets = flip((0:num_pairs-1) * offset_percent);

% Figure pour afficher les courbes, les pics et les minima détectés
figure;
hold on;
colors = lines(num_pairs);

for i = 1:num_pairs
    % Application de l'offset aux courbes lissées
    offset_strain = smoothed_strain(:, i) + offsets(i);
    
    % Courbes lissées avec offset
    plot(time_vector(2:end), offset_strain, 'Color', colors(i, :), ...
        'DisplayName', ['Paire ' num2str(i)]);
    
    
    if i == 1
    % Détection des pics (maximums) sur les données SANS offset
        minpeakprominence = minpeakSerosa;
    elseif i == 2
        minpeakprominence = minpeakMid;
    else
        minpeakprominence = minpeak;
    end
        
    [pks, locs, width] = findpeaks(smoothed_strain(:, i), 'MinPeakProminence', minpeakprominence, 'WidthReference', 'halfprom');
    peaks{i} = pks; 
    locations{i} = locs;
    
    % Détection des minima (courbe inversée) sur les données SANS offset
    [mins, min_locs] = findpeaks(-smoothed_strain(:, i), 'MinPeakProminence', minpeakprominence);
    local_mins = -mins; % Revenir aux vraies valeurs positives des minima
    
    % Ajout des pics sur le graphique AVEC offset
    plot(time_vector(locs + 1), pks + offsets(i), 'o', 'Color', colors(i, :), ...
        'DisplayName', ['Pics Paire ' num2str(i)]);  
    
    % Ajout des minima locaux sur le graphique AVEC offset
    plot(time_vector(min_locs + 1), local_mins + offsets(i), 'v', 'Color', colors(i, :), ...
        'DisplayName', ['Minima Paire ' num2str(i)]);  
    
    % Calcul des amplitudes manuelles entre pics et minima (SANS offset car c'est une différence)
    amplitudes = NaN(size(pks));
    for k = 1:length(locs)
        idx_min = find(min_locs < locs(k), 1, 'last');
        if ~isempty(idx_min)
            amplitudes(k) = pks(k) - local_mins(idx_min);
        end
    end
    amplitude_table(i) = mean(amplitudes, 'omitnan');
    peak_data{i} = length(locs); % stocker le nombre de pics dans la matrice
    frequency(i) = peak_data{i} / time_total_min;
    width_time = width * time_step;
    width_min = width_time / 60;
    width_data{i} = mean(width_min);
    % SD
    amplitude_std(i) = std(amplitudes, 'omitnan');
    width_std(i) = std(width_min);
end

xlabel('Temps (s)');
ylabel('Amplitude (%)');
title('Amplitude lissée au cours du temps - Affichage décalé - Séreuse (haut), Milieu myomètre (milieu), Endomètre (bas)');
legend('Location', 'eastoutside');
grid on;
hold off;

% Frequency calculations per 10 minutes
frequency_10min = frequency * 10;
mean_frequency_10min = mean(frequency_10min);
std_frequency_10min = std(frequency_10min);



% Results
results_table = table((1:num_pairs)', cell2mat(peak_data)', amplitude_table', width_data', frequency_10min', 'VariableNames', {'Pairs', 'Number of contractions', 'Amplitude', 'Width', 'Frequency'});
disp(results_table);
nb_contractions = cell2mat(peak_data);
moyenne_nb_contractions = mean(nb_contractions);
disp('Moyenne points de contractilité sur la tranche');
disp(moyenne_nb_contractions);
disp('Mean Frequency per 10 minutes');
disp(mean_frequency_10min);

% Moyennes et écarts-types des amplitudes
mean_strain = zeros(1, num_pairs);
std_strain = zeros(1, num_pairs);

for i = 1:num_pairs
    mean_strain(i) = mean(smoothed_strain(:,i));
    std_strain(i) = std(smoothed_strain(:,i));
end

% Affichage des moyennes avec barres d'erreur
figure;
hold on;
bar(1:num_pairs, amplitude_table, 'FaceColor', 'flat', 'FaceAlpha', 0.7);
errorbar(1:num_pairs, amplitude_table, std_strain, 'k.', 'LineWidth', 1.5); % Barres d'erreur
xlabel('Index des paires');
ylabel('Amplitude moyenne (%)');
title('Amplitude moyenne et écart-type des strain par paire');
grid on;
hold off;

% Offset des courbes : Paire 1 (haut), Paire 2 (milieu), Paire 3 (bas)
offsets = flip((0:num_pairs-1) * offset_percent);

% Figure amplitude
figure;
hold on;
colors = lines(num_pairs); % Couleurs pour chaque courbe
for i = 1:num_pairs
    offset_strain = smoothed_strain(:, i) + offsets(i); % Application de l'offset
    plot(time_vector(2:end), offset_strain, 'Color', colors(i, :), ...
        'DisplayName', sprintf('Paire %d ', i));
end
xlabel('Temps (s)');
ylabel('Amplitude (%)');
title('Amplitde en fonction du temps - Affichage décalé - Séreuse (haut), Milieu myomètre (milieu), Endomètre (bas)');
legend('Location', 'eastoutside');
grid on;
hold off;


% Enregistrement des résultats
if ~isfolder(folder_path)
    mkdir(folder_path); % Crée le dossier s'il n'existe pas
end
full_path = fullfile(folder_path, file_name); 
all_figures = flipud(findall(0, 'Type', 'figure'));

% Sauvegarde de toutes les variables sauf les handles de figures
variables_to_save = who; % Liste de toutes les variables dans l'espace de travail
if isfile(full_path) % Vérifier si le fichier existe déjà
    disp('ATTENTION !!!! Rename file_name !');
else
    save(full_path, variables_to_save{:}); % Sauvegarder les variables
end