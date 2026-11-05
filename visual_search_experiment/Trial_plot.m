function Results = Trial_plot( Stimuli, Trial_matrix)


for i = 1:size(Trial_matrix,1)
    Cond = Trial_matrix(i,1);
    DisN = Trial_matrix(i,2);
    TarG = Trial_matrix(i,3);


    % 이전에 그린 도형 지우기 
    clf;
    axis([0 10 0 10]);
    axis equal;
    axis off; % 축 제거 
    hold on;

    x = Stimuli(i).distractorXY(:,1);
    y = Stimuli(i).distractorXY(:,2);


    for d = 1:DisN
        if Cond == 1
            rectangle('Position',[x(d) y(d) 1 1], ...
                      'Curvature',[1 1], 'FaceColor','g')
        
        elseif Cond == 0 & d <= DisN/2
            rectangle('Position',[x(d) y(d) 1 1], ...
                      'Curvature',[1 1], 'FaceColor','r')
        
        elseif Cond == 0 & d > DisN/2
            rectangle('Position',[x(d) y(d) 1 1], 'FaceColor','g')
        end
    end    

    if TarG == 1
        TargetX = Stimuli(i).targetXY(:,1);
        TargetY = Stimuli(i).targetXY(:,2);
        
        rectangle('Position',[TargetX TargetY 1 1],'FaceColor','r')
    end
    % 참가자가 각 화면에서 Target이 있는지 없는지 키보드로 응답하도록 만들기

    drawnow; % 현재 Trial의 도형을 화면에 갱신 
    %pause(0.3);
    tStart = tic; % 시간 측정 시작 

    while true
        pressed = waitforbuttonpress; % 참가지의 키 입력 기다림
        if pressed == 1
            key = lower(get(gcf,'CurrentCharacter')); % 참가자가 누른 키 확인
            if key == 'f' || key == 'j'
                RT(i) = toc(tStart); % 반응까지 걸린 시간 계산
                break;
            end
        end
    end
    % Response와 Accuracy 계산
    if key == 'f'
        Response(i) = 1;
    elseif key == 'j'
        Response(i) = 0;
    end
    Accuracy(i) = Response(i) == TarG;
    
end % for i 종료 

% 계산된 데이터를 하나로 묶어 반환할 값 만들기 
Results = table( ...
    Trial_matrix(:,1), ...
    Trial_matrix(:,2), ...
    Trial_matrix(:,3), ...
    Response(:), ...
    RT(:), ...
    Accuracy(:), ...
    'VariableNames', ...
    {'Condition','DistrNum','Target', ...
     'Response','RT_sec','Accuracy'});

end % 함수 종료 