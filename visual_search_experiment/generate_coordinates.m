function Stimuli = generate_coordinates(Trial_matrix)

    % 1. 좌표 후보 49개 생성
    positions = 1:1.2:8.2;
    [X,Y] = meshgrid(positions,positions);

    allXY = [X(:), Y(:)];

    % 2. 전체 Trial 개수
    nTrials = size(Trial_matrix,1);

    % 3. 결과를 저장할 구조체 배열
    Stimuli = repmat(struct('distractorXY', [], ...
                           'targetXY', []), nTrials, 1);

    % 4. Trial별 좌표 생성
    for i = 1:nTrials

        DisN = Trial_matrix(i,2);
        TarG = Trial_matrix(i,3);

        % 중복 없는 위치 선택
        idx = randperm(size(allXY,1), DisN + TarG);

        % Distractor 좌표
        Stimuli(i).distractorXY = allXY(idx(1:DisN),:);

        % Target 좌표
        if TarG == 1
            Stimuli(i).targetXY = allXY(idx(end),:);
        end

    end
end