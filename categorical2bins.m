function New_dataset = categorical2bins(dataset, vars)
    num_var = size(vars,2);
    ins_size = size(dataset,1);
    New_dataset = dataset;
    for i = 1:num_var
        intend = dataset(:,vars(i));
        in_var = unique(intend);
        num_in = size(in_var,1);
        for j = 1:(num_in-1)
            int_var = in_var(j,1);
            new_col = zeros(ins_size,1);
            for k = 1:ins_size
                if strcmp(intend(k,1),int_var) %intend(k,1) == int_var
                    new_col(k,1) = 1;
                end
            end
            new_col = num2cell (new_col);
            New_dataset = horzcat(New_dataset,new_col); %[New_dataset,new_col];
            new_col = zeros(ins_size,1);
        end
    end
New_dataset(:,vars) = [];
New_dataset = cell2mat(New_dataset);
end