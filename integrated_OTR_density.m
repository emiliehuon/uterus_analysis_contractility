close all;
%% ================= PARAMÈTRES =================

file_title = 'Distribution_OTR_axe_Sereuse_Endometre n=19';

group1_name = 'Adenomyosis';
group2_name = 'Contrôle';

group1_indices = 1:10;
group2_indices = 11:19;

n_interp_points = 100;

save_folder = 'C:\Users\Emilie\Documents\Epifluorescence\OTR et asma\analyses OTR\analyses interpatientes';

zone_edges = [0.1 0.25 0.5 0.75 0.9];

%% ================= 1. PREPARATION =================

data(data==0) = NaN;
curve(curve==0) = NaN;

[n_points, n_curves] = size(data);

x_common = linspace(0,1,n_interp_points);
interpolated_curves = NaN(n_curves, n_interp_points);

%% ================= 2. INTERPOLATION =================

for c = 1:n_curves
    
    signal = data(:,c);
    pos    = curve(:,c);

    valid = ~isnan(signal) & ~isnan(pos);
    signal = signal(valid);
    pos    = pos(valid);

    if numel(signal) < 2
        continue
    end

    [pos_sorted, order] = sort(pos);
    signal_sorted = signal(order);

    [pos_unique, ia] = unique(pos_sorted);
    signal_unique = signal_sorted(ia);

    interpolated_curves(c,:) = interp1(pos_unique, signal_unique, x_common, 'pchip', NaN);
end

%% ================= 3. GROUPES =================

g1 = interpolated_curves(group1_indices,:);
g2 = interpolated_curves(group2_indices,:);

%% ================= 4. MOYENNES + SD =================

mean_all = mean(interpolated_curves,1,'omitnan');
std_all  = std(interpolated_curves,0,1,'omitnan');

mean_g1 = mean(g1,1,'omitnan');
std_g1  = std(g1,0,1,'omitnan');

mean_g2 = mean(g2,1,'omitnan');
std_g2  = std(g2,0,1,'omitnan');

%% ================= 5. FIGURES =================

figure;

fill([x_common fliplr(x_common)], ...
     [mean_all-std_all fliplr(mean_all+std_all)], ...
     'k','FaceAlpha',0.15,'EdgeColor','none');
plot(x_common, mean_all,'k','LineWidth',2)
%title([file_title ' - Global'])
xlabel('Serosa = 0 Endometrium = 1')
ylabel('% area OTR')
grid on

figure;

fill([x_common fliplr(x_common)], ...
     [mean_g1-std_g1 fliplr(mean_g1+std_g1)], ...
     [0.914 0.624 0.671],'FaceAlpha',1,'EdgeColor','none');

fill([x_common fliplr(x_common)], ...
     [mean_g2-std_g2 fliplr(mean_g2+std_g2)], ...
     [0.18 0.18 0.18],'FaceAlpha',0.3,'EdgeColor','none');

plot(x_common, mean_g1,'Color',[0.78 0.06 0.18],'LineWidth',2)
plot(x_common, mean_g2,'Color',[0.49 0.58 0.72],'LineWidth',2)

%legend(group1_name, group2_name,'Location','best')
%title([file_title ' - Groupes'])
%xlabel('Position normalisée')
%ylabel('% aire OTR')
grid on

%% ================= 6. AUC =================

n_zones = length(zone_edges)-1;
AUC_zones = NaN(n_curves, n_zones);

for c = 1:n_curves
    
    y = interpolated_curves(c,:);
    
    for z = 1:n_zones
        
        idx = x_common >= zone_edges(z) & x_common <= zone_edges(z+1);
        
        xz = x_common(idx);
        yz = y(idx);
        
        valid = ~isnan(yz);
        
        if sum(valid) > 1
            AUC_zones(c,z) = trapz(xz(valid), yz(valid));
        end
    end
end

%% ================= 7. PENTES =================

slopes = NaN(n_curves,1);

for c = 1:n_curves
    y = interpolated_curves(c,:);
    valid = ~isnan(y);
    
    if sum(valid) > 2
        p = polyfit(x_common(valid), y(valid), 1);
        slopes(c) = p(1);
    end
end

%% ================= 8. TABLES RESULTATS =================

% Table AUC (zones x patients)
AUC_table = array2table(AUC_zones', ...
    'VariableNames', strcat('Pat_', string(1:n_curves)), ...
    'RowNames', strcat('Zone_', string(1:n_zones)));

% Table slopes
slopes_table = table(slopes, ...
    'VariableNames', {'Slope'});

% Table résumé par groupe
summary_table = table( ...
    [mean(mean_all,'omitnan'); mean(mean_g1,'omitnan'); mean(mean_g2,'omitnan')], ...
    [median(mean_all,'omitnan'); median(mean_g1,'omitnan'); median(mean_g2,'omitnan')], ...
    [mean(std_all,'omitnan'); mean(std_g1,'omitnan'); mean(std_g2,'omitnan')], ...
    'VariableNames', {'Mean','Median','Std'}, ...
    'RowNames', {'Global','Adenomyose','Controle'});

%% ================= 9. SAVE =================

filename_mat = fullfile(save_folder, [file_title '.mat']);
filename_fig = fullfile(save_folder, [file_title '.fig']);

if isfile(filename_mat)
    warning('Fichier existant, veuillez renommer le file_title avant de sauvegarder.');
else
    save(filename_mat);
    savefig(gcf, filename_fig);
end