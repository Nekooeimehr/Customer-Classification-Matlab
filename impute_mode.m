function [matrixdata] = impute_mode(matrixdata, vars)
for i=1: size(matrixdata,2)
    cv = matrixdata(:,i);
    if ismember(i,vars)
        cv4 = cv;
        cv4(strcmp('NA', cv))= [];
%         missings = find(cellfun(@(x) all(isnan(x)),cv));
%         cv(missings) = {'NaN'};
        cv3 = categorical(cv4);
        cv2 = categorical(cv);
        %cv2 = cv;
    % labels = unique(cv2);
        [a, b]= hist(cv3);
        [modeValue modeInd] = max(a);
        fck = strcmp('NA', cv);
        sum(fck)
        cv2(fck) = b(1,modeInd);
        cv5 = cellstr(cv2);
        matrixdata(:,i) = cv5;
    else
        cv(strcmp('NA', cv))= {NaN};
        cv = cell2mat(cv);
        cv(isnan(cv)) = mode(cv);
        cv = num2cell(cv);
        matrixdata(:,i) = cv;
    end
end