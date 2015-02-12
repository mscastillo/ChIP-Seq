
close all force ;
clear all ;
clc

%% PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

peaksfile = '~/Projects/vasilis/histones/BG362.counts.bed' ;
color1 = rgb2hsv( [1 0.2 0.2] ) ; cm1 = hsv2rgb([ color1(1)*ones(100,1) color1(2)*ones(100,1) linspace(0,color1(3),100)' ]) ;
color2 = rgb2hsv( [0.1 0.9 0.1] ) ; cm2 = hsv2rgb([ color2(1)*ones(100,1) color2(2)*ones(100,1) linspace(0,color2(3),100)' ]) ;

%% LOADING THE DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp( ['Loading data...'] ) ;
[ files,path ] = uigetfile( {'*.matrix','Matrix in TSV format';'*.*','All files (*.*)'},'MultiSelect','on' ) ;
pds = dataset( 'File',peaksfile,'Delimiter','\t','HeaderLines',0,'ReadVarNames',false,'ReadObsNames',false ) ;
[peak_counts peak_index] = sort( double(pds(:,4)),'descend' ) ;
saturation_peak_cutoff = 90 ;
saturation_histones_cutoff = 98 ;

%% CALCULATING THE MAXIMUM VALUES AND THE PLOT LIMITS %%%%%%%%%%%%%%%%%%%%%

y_lim = 0 ;
for k = 1:numel( files )
    
  ds = dataset( 'File',strjoin({path,files{k}},''),'Delimiter','\t','HeaderLines',1,'ReadVarNames',false,'ReadObsNames',false ) ;
  m = double( ds(:,2:end) ) ;
  maximum(k) = prctile(m(:),saturation_histones_cutoff) ;
  y_lim = max( [ y_lim sum(m,1) ] ) ;
 
end%for

%% PLOTING THE PEAKS PROFILES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 figure(numel(files)+1) ;
  set(gcf,'Position', [1900/6, 100, 1900/12/2, 1000]) ;
% subplot(4,1,1) ;
  subplot(4,2,[3 5 7]+1) ;
    imagesc( peak_counts,[min(peak_counts) floor(prctile(peak_counts,saturation_peak_cutoff))] ) ;
    colormap( cm1 ) ; clbr = colorbar('SO') ;
    set( clbr,'XTick',[min(peak_counts) floor(prctile(peak_counts,saturation_peak_cutoff))],'XTickLabel',[min(peak_counts) floor(prctile(peak_counts,saturation_peak_cutoff))] )
    axis off ; title( 'Peaks' ) ;  
  set(gcf,'Units','pixels') ;
  set( gcf,'PaperSize',[1.33*21.1*1900/12/1000 29.7] ) ;
  set( gcf,'PaperPositionMode','auto' ) ;
  saveas( gcf,strjoin({path,'heatmap_peaks'},''),'pdf' ) ;

%% PLOTTING THE FOLD CHANGE AND PEAKS PROFILES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
for k = 1:numel( files )
        
  [~,name] = fileparts(files{k}) ;
  ds = dataset( 'File',strjoin({path,files{k}},''),'Delimiter','\t','HeaderLines',1,'ReadVarNames',false,'ReadObsNames',false ) ;
  peak_id = double( ds(:,1) ) ;
  m = double( ds(:,2:end) ) ;
  data = zeros(numel(peak_index),size(m,2)) ;
  for i = 1:numel(peak_index)
      position = find(peak_id == peak_index(i)) ;
      if isempty(position) == 0
          data(i,:) = m(position,:) ;
      end%if
  end%for
  m = data(peak_index,:) ;
  figure(k) ;
  set(gcf,'Position', [1900/6, 100, 1900/12, 1000]) ;
  subplot(4,1,1) ; 
    plot((-1000:10:1000),sum(m,1)) ; 
    ylim([0 y_lim]) ;
    grid on ;
  subplot(4,1,[2 3 4])
    imagesc(m,[min(m(:)) max(maximum) ]) ;
    colormap( cm2 ) ;
    clbr = colorbar('SO') ; 
    set( clbr,'XTick',[min(m(:)) max(maximum)] ) ;
    axis off ; title( strjoin(strsplit(name,'_'),' - ') ) ;  
  set(gcf,'Units','pixels') ;
  set( gcf,'PaperSize',[1.33*21.1*1900/12/1000 29.7] ) ;
  set( gcf,'PaperPositionMode','auto' ) ;
  saveas( gcf,strjoin({path,name,'_heatmap_sorted_by_peaks'},''),'pdf' ) ;
  
end%for
