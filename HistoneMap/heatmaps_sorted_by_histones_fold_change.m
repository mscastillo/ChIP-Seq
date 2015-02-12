
close all force ;
clear all ;
clc

%% PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

peaksfile = 'example/peaks.counts.bed' ;
histone2 = 'example/histone002.matrix' ;
histone1 = 'example/histone002.matrix' ;
color1 = rgb2hsv( [1 0.2 0.2] ) ; cm1 = hsv2rgb([ color1(1)*ones(100,1) color1(2)*ones(100,1) linspace(0,color1(3),100)' ]) ;
color2 = rgb2hsv( [0.4 1 0.2] ) ; cm2 = hsv2rgb([ color2(1)*ones(100,1) color2(2)*ones(100,1) linspace(0,color2(3),100)' ]) ;

%% LOADING THE DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp( ['Loading data...'] ) ;
[ files,path ] = uigetfile( {'*.matrix','Matrix in TSV format';'*.*','All files (*.*)'},'MultiSelect','on' ) ;
pds = dataset( 'File',peaksfile,'Delimiter','\t','HeaderLines',0,'ReadVarNames',false,'ReadObsNames',false ) ;
[peak_counts peak_index] = sort( double(pds(:,4)),'descend' ) ;

%% CALCULATING THE MAXIMUM VALUES AND THE PLOT LIMITS %%%%%%%%%%%%%%%%%%%%%

y_lim = 0 ;
for k = 1:numel( files )
    
  ds = dataset( 'File',strjoin({path,files{k}},''),'Delimiter','\t','HeaderLines',1,'ReadVarNames',false,'ReadObsNames',false ) ;
  m = double( ds(:,2:end) ) ;
  maximum(k) = max( max(m(:)) ) ;
  y_lim = max( [ y_lim sum(m,1) ] ) ;
 
end%for

%% GENERATING THE FOLD CHANGE PROFILE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[~,name1] = fileparts(histone1) ;
ds1 = dataset( 'File',strjoin({path,histone1},''),'Delimiter','\t','HeaderLines',1,'ReadVarNames',false,'ReadObsNames',false ) ;
m1 = double( ds1(:,2:end) ) ;
peak_id = double( ds1(:,1) ) ;
data = zeros(numel(peak_index),size(m1,2)) ;
for i = 1:numel(peak_index)
   position = find(peak_id == peak_index(i)) ;
   if isempty(position) == 0
      data(i,:) = m1(position,:) ;
   end%if
end%for
m1 = data ;

[~,name2] = fileparts(histone2) ;
ds2 = dataset( 'File',strjoin({path,histone2},''),'Delimiter','\t','HeaderLines',1,'ReadVarNames',false,'ReadObsNames',false ) ;
m2 = double( ds2(:,2:end) ) ;
peak_id = double( ds2(:,1) ) ;
data = zeros(numel(peak_index),size(m2,2)) ;
for i = 1:numel(peak_index)
   position = find(peak_id == peak_index(i)) ;
   if isempty(position) == 0
      data(i,:) = m2(position,:) ;
   end%if
end%for
m2 = data ;

fold_change = (m1+1)./(m2+1) ;
fold_change(isinf(fold_change)) = 0 ; fold_change(isnan(fold_change)) = 0 ;
fold_change_sum = mean(fold_change,2) ;
%fold_change_sum = sum(m1,2)./sum(m2,2) ;
fold_change_sum(isinf(fold_change_sum)) = 0 ; fold_change_sum(isnan(fold_change_sum)) = 0 ;
[ values indexes ] = sort( fold_change_sum,'descend' ) ;

%% PLOTING THE FOLD CHANGE AND PEAKS PROFILES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 figure(numel(files)+1) ;
  set(gcf,'Position', [1900/6, 100, 1900/12, 1000]) ;
%  subplot(4,1,1) ; 
  subplot(4,1,[2 3 4]) ;
    imagesc(fold_change(indexes,:),[0 max(fold_change(:))]) ; colormap( cm2 ) ; clbr = colorbar('SO') ; set( clbr,'XTick',[eps max(fold_change(:))] )
    axis off ; % title( strjoin([strsplit(name1,'_'),'over',strsplit(name2,'_')]) ) ;
  set(gcf,'Units','pixels') ;
  set( gcf,'PaperSize',[1.33*21.1*1900/12/1000 29.7] ) ;
  set( gcf,'PaperPositionMode','auto' ) ; title( [strjoin(strsplit(name1,'_'),'-'),char(10),repmat('_',1,max([numel(name1) numel(name2)])),char(10),char(10),strjoin(strsplit(name2,'_'),'-')] ) ;
  saveas( gcf,strjoin({path,name1,'_over_',name2,'_heatmap'},''),'pdf' ) ;
  
 figure(numel(files)+2) ;
  set(gcf,'Position', [1900/6, 100, 1900/12, 1000]) ;
%  subplot(4,1,1) ; 
  subplot(4,2,[3 5 7]) ;
    imagesc(peak_counts(indexes),[0 max(peak_counts(:))]) ; colormap( cm1 ) ; clbr = colorbar('SO') ; set( clbr,'XTick',[min(peak_counts(:)) max(peak_counts(:))],'XTickLabel',[round(eps)*0.0 max(peak_counts(:))] )
    axis off ; title( 'Peaks' ) ;  
  subplot(4,2,[4 6 8]) ;
    imagesc(fold_change_sum(indexes),[0 floor(max(fold_change_sum))]) ; colormap( cm1 ) ; clbr = colorbar('SO') ; set( clbr,'XTick',[0 floor(max(fold_change_sum))] )
    axis off ; title( 'Fold change' ) ;
  set(gcf,'Units','pixels') ;
  set( gcf,'PaperSize',[1.33*21.1*1900/12/1000 29.7] ) ;
  set( gcf,'PaperPositionMode','auto' ) ;
  saveas( gcf,strjoin({path,name1,'_over_',name2,'_counts'},''),'pdf' ) ;

%% PLOTTING INDIVIDUAL RPOFILES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
for k = 1:numel( files )
    
    
  [~,name] = fileparts(files{k})
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
  m = data(indexes,:) ;
  
 figure(k) ;
  set(gcf,'Position', [1900/6, 100, 1900/12, 1000]) ;
  subplot(4,1,1) ;
    plot((-1000:10:1000),sum(m,1)) ;
    ylim([0 y_lim]) ;
    grid on ;
  subplot(4,1,[2 3 4])
    imagesc(m,[0 max(maximum(:))]) ; colormap( cm2 ) ; clbr = colorbar('SO') ; set( clbr,'XTick',[eps floor(max(maximum(:)))] )
    axis off ; title( strjoin(strsplit(name,'_'),' - ') ) ;
  
  set(gcf,'Units','pixels') ;
  set( gcf,'PaperSize',[1.33*21.1*1900/12/1000 29.7] ) ;
  set( gcf,'PaperPositionMode','auto' ) ;
  saveas( gcf,strjoin({path,name,'_heatmap_sorted_by_',name1,'_over_',name2},''),'pdf' ) ;
  
  
end%for
