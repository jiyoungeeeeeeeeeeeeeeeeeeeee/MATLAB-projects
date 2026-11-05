function info = main_experiment(repeat_number)
    answer = inputdlg( ...
        {'Participants ID'}, ...
        'Visual Search Experiment', ...
        [1 40], ...
        {'P001'});
    % 취소한 경우 종료 
    if isempty(answer)
        disp('Experiment cancelled')
        return
    end

    % 셀 안의 문자열 반환  
    ID = answer{1}; % id 생성
    
    % 함수 실행 
    Trial_matrix = load_trial(repeat_number);
    Stimuli = generate_coordinates(Trial_matrix);
    Results = Trial_plot( Stimuli, Trial_matrix);
    
    % 참가자 ID 저장
    info = Results;
    info.ID = repmat( ...
    string(ID), size(Results,1), 1); 

    % 결과 저장 폴더 생성
    resultFolder = fullfile(pwd,'experiment_results');

    if ~exist(resultFolder , 'dir')
        mkdir(resultFolder);
    end

    % dir 만들기 및 자동 저장 
    timeStamp = datestr(now , 'yyyymmdd_HHMMSS');
    safeID = regexprep(ID, '[^A-Za-z0-9_-]', '_');
    fileName = [safeID, '_', timeStamp, '.mat'];

    filePath = fullfile(resultFolder, fileName);
    save(filePath, 'info');

    disp(['Saved: ' filePath]);

end 