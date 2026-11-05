function[Trial_matrix] = load_trial(repeat_number)
condition = [0,1];
DistrNum = [6,12,18,48];
Target = [0,1];
Trial_matrix = []

for i = 1:length(condition);
    for j = 1:length(DistrNum);
        for k = 1:length(Target);
            Trial_matrix = [Trial_matrix; condition(i),DistrNum(j),Target(k)];
        end
    end
end

Trial_matrix = repmat(Trial_matrix,repeat_number,1);
idx = randperm(16*(repeat_number/2));
Trial_matrix = Trial_matrix(idx,:);
end