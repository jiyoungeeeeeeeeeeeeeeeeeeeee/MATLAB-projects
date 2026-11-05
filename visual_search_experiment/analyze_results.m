function analysis = analyze_results(filePath) % 경로 미리 저장 
    
    experiment_data = load(filePath); 

    condition = experiment_data.info.Condition;
    distrNum  = experiment_data.info.DistrNum;
    accuracy  = experiment_data.info.Accuracy;
    Target    = experiment_data.info.Target;

    
    conditions   = [0 1];
    distractions = [6 12 18 48];
    targets      = [0 1];
    means        = zeros(2,4,2); %(condition,distraction,target)
    accuracyRates = zeros(2,4,2);

    for c = 1:length(conditions)
        for d = 1:length(distractions)
            for t = 1:length(targets)
                idx = (condition == conditions(c)) & (distrNum == distractions(d))... 
                & accuracy == 1 & (Target == targets(t));

                idx_all = (condition == conditions(c)) & ... %accuracy전용 
                (distrNum == distractions(d)) & ...
                (Target == targets(t));

                selected_data = experiment_data.info(idx,:);

                selected_accuracy = accuracy(idx_all);
                accuracyRates(c,d,t) = mean(selected_accuracy) * 100; % research question 2
                RT_sec = selected_data.RT_sec;
                RT_mean = mean(RT_sec);
                means(c,d,t) =  RT_mean
            end
        end
    end
    
    % distraction의 개수에 따른 mean RT 그래프 
    figure;
    plot(distractions,means(1,:,1),'o-')
    hold on
    
    plot(distractions,means(2,:,1), 'o-')
    
    xlabel('Number of distractors')
    ylabel('Mean Reaction Time (s)')

    % Linear Regression 
    % p(1)=Slope(기울기) p(2)=Intercept(절편)
    x = distractions;
    slopes = zeros(2,2) % (condition,target)
    R2 = zeros(2,2) 
    fits = zeros(2,4,2)

    for c = 1:2     % 기울기 행렬 만들기 
        subplot(1,2,c)
        hold on 

        for t = 1:2
            y = means(c,:,t);
            p = polyfit(x,y,1); % 회귀계수 계산 
            slopes(c,t) = p(1) * 1000; % 기울기(ms/item)저장
            fit = polyval(p,x) % 회귀직선 계산 (반응시간 예측값(Predicted RT))
            fits(c,:,t) = fit; % 배열에 저장 
            acc_y = accuracyRates(c,:,t);
            
            plot(x,y,'o')   % 실제 평균 RT
            plot(x,fit,'--') % 회귀 예측 RT
            hold on 
            

            % 회귀모델 적합도 평가 (결정계수 계산)
    
            observed = means(c,:,t);
            predicted = fits(c,:,t);

            SSE = sum((observed - predicted).^2);
            SST = sum((observed - mean(observed)).^2);
            R2(c,t) = 1-(SSE/SST);

        end   
    end
    xlabel('Number of distractors')
    ylabel('Predicted Reaction Time (s)')
    legend('Absent Mean', 'Absent Fit', ...
           'Present Mean', 'Present Fit')
    figure;

    % accuracy 그래프 그리기 
    for c = 1:2
        subplot(1,2,c);
        hold on
    
        for t = 1:2
            acc_y = accuracyRates(c,:,t);
    
            plot(distractions, acc_y, 'o-');
        end
    
        xlabel('Number of distractors');
        ylabel('Accuracy (%)');
        ylim([0 100]);
    
    legend('Target Absent', 'Target Present');
    
      
    end

    % conjunctive에서 target 0/1 기울기 차이
    Cslopes_diff = slopes(1,1) - slopes(1,2);
    Pslopes_diff = slopes(2,1) - slopes(2,2);

    
    % struct에 slopes(회귀기울기),R2,means(실제 평균RT/16),fits(예측RT) 저장
    analysis = struct();
    analysis.means = means;
    analysis.fits = fits;
    analysis.R2 = R2;
    analysis.slopes = slopes;
    analysis.conditions = conditions;
    analysis.distractions = distractions;
    analysis.targets = targets;
    analysis.Cslopes_diff = Cslopes_diff;
    analysis.Pslopes_diff = Pslopes_diff;
    analysis.accuracyRates = accuracyRates;

    [folder, name, ext] = fileparts(filePath);
    projectFolder = fileparts(folder);
    resultFolder = fullfile(projectFolder, 'analysis_results');

    % Step 3. 폴더 생성
    if ~exist(resultFolder, 'dir')
        mkdir(resultFolder);
    end

    % Step 4. 파일 저장
    fileName = ['analysis_', name, '.mat'];
    savePath = fullfile(resultFolder, fileName);

    save(savePath, 'analysis');

    disp(['Analysis saved: ', savePath]);
    
end
