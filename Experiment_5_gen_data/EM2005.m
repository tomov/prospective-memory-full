function [data, extra] = EM2005( params, exp_id )
% run a simulation of the E&M with certain parameters and spit out the data
% for all subjects

% parse parameters

params
focal_low_init_wm = params(1:4);
focal_high_init_wm = params(5:8);
nonfocal_low_init_wm = params(9:12);
nonfocal_high_init_wm = params(13:16);
bias_for_task = params(17);
bias_for_attention = params(18);

assert(exp_id == 1 || exp_id == 2 || exp_id == 3 || exp_id == 5);
fprintf('\n\n--------========= RUNNING E&M EXPERIMENT %d ======-------\n\n', exp_id);

% from E&M Experiment 1 & 2 methods
subjects_per_condition = 1000; % 24;
blocks_per_condition = [8 4 8 NaN 1];  % exp 1, exp 2, exp 3 (= exp 1 for now), exp 4 TBD, exp 5
trials_per_block = [24 40 24 NaN 52]; % exp 1, exp 2, exp 3 (= exp 1 for now), exp 4 TBD, exp 5
pm_blocks_exp1 = [1 3 6 7];
pm_trials_exp2 = [40 80 120 160]; % 20 60 100 140];

% since we're doing only 1 experiment at a time
blocks_per_condition = blocks_per_condition(exp_id);
trials_per_block = trials_per_block(exp_id);

data = [];
extra = [];

og_range = 0:1;
focal_range = 1:-1:0;
emphasis_range = 0:1;
target_range = [1, 6];

if exp_id == 1
    target_range = [1];
elseif exp_id == 2
    target_range = [1];
    emphasis_range = 0;
elseif exp_id == 3
    focal_range = 1;
elseif exp_id == 5
    og_only_range = 0;
    target_range = [1];
    emphasis_range = 0;
    focal_range = 1;
end

for OG_ONLY = 0 %og_range
    for FOCAL = 1 % focal_range
        for EMPHASIS = 0 %emphasis_range
            for TARGETS = 1

                % init OG trial pool
                og_stimuli = [
                    {'crocodile,an animal'}, 1;
                    {'crocodile,a subject'}, 1;
                    {'physics,an animal'}, 1;
                    {'physics,a subject'}, 1;
                    {'math,an animal'}, 1;
                    {'math,a subject'}, 1;
                ];
                og_correct = {'Yes'; 'No'; 'No'; 'Yes'; 'No'; 'Yes'};

                % init PM trial pool
                pm_targets = [
                    {'tortoise,an animal'}, 1;
                    {'tortoise,a subject'}, 1;
                ];
                pm_og_correct = {'Yes'; 'No'};
                pm_correct = {'PM', 'PM'};

                % generate OG block
                og_block = repmat(og_stimuli, trials_per_block, 1);
                og_block_correct = repmat(og_correct, trials_per_block, 1);
                og_block = og_block(1:trials_per_block,:);
                og_block_correct = og_block_correct(1:trials_per_block,:);

                % generate trial sequence (all blocks concatenated)
                stimuli = repmat(og_block, blocks_per_condition, 1);
                correct = repmat(og_block_correct, blocks_per_condition, 1);
                og_correct = correct;
                is_target = zeros(blocks_per_condition * trials_per_block, 1);

                % insert one PM target in each of the PM blocks
                if ~OG_ONLY
                    % every third trial is a PM trial -- this is only for
                    % testing; not used in any of E&M's experiments

                    %{
                    for i = 1:length(stimuli)
                        if mod(i,4) == 0
                            target_id = mod(i, size(pm_targets, 1)) + 1;
                            middle = i;
                            stimuli(middle,:) = pm_targets(target_id, :);
                            correct(middle) = pm_correct(target_id);
                            og_correct(middle) = pm_og_correct(target_id);
                            is_target(middle) = 1;
                        end
                    end
                    %}


                    if exp_id == 1 || exp_id == 3
                        % in experiment 1, there is a target in blocks 1, 3, 6, 7
                        for i = 1:length(pm_blocks_exp1)
                            b = pm_blocks_exp1(i);
                            block_start = (b - 1) * trials_per_block + 1;
                            block_end = b * trials_per_block;
                            middle = int32((block_start + block_end) / 2);
                            target_id = mod(i, size(pm_targets, 1)) + 1;

                            stimuli(middle,:) = pm_targets(target_id, :);
                            correct(middle) = pm_correct(target_id);
                            og_correct(middle) = pm_og_correct(target_id);
                            is_target(middle) = 1;
                        end
                    elseif exp_id == 2
                        % in experiment 2, trials 40, 80, 120, and 160 are
                        % targets
                        for i = 1:length(pm_trials_exp2)
                            target_id = mod(i, size(pm_targets, 1)) + 1;
                            trial = pm_trials_exp2(i);
                            stimuli(trial,:) = pm_targets(target_id, :);
                            correct(trial) = pm_correct(target_id);
                            og_correct(trial) = pm_og_correct(target_id);
                            is_target(trial) = 1;                        
                        end
                    end

                end
                
                
                if exp_id == 5
                    inter_stimuli = [
                        {'dog'}, 1;
                        {'dog'}, 1;
                        {'monkey'}, 1;
                        {'crocodile'}, 1;
                        {'kiwi'}, 1;
                        {'cat'}, 1;
                        {'crocodile'}, 1;
                        {'dog'}, 1;
                        {'crocodile'}, 1;
                        {'tortoise'}, 1;
                    ];
                    inter_correct = {'Yes'; 'Yes'; 'No'; 'No'; 'No'; 
                        'Yes'; 'No'; 'Yes'; 'No'; 'No'};
                    inter_is_target = [0; 0; 0; 0; 0; 0; 0; 0; 0; 1];

                    % copy & trim 'em
                    inter_stimuli = repmat(inter_stimuli, trials_per_block, 1);
                    inter_correct = repmat(inter_correct, trials_per_block, 1);
                    inter_is_target = repmat(inter_is_target, trials_per_block, 1);
                    inter_stimuli = inter_stimuli(1:trials_per_block,:);
                    inter_correct = inter_correct(1:trials_per_block,:);
                    inter_is_target = inter_is_target(1:trials_per_block,:);
                    
                    stimuli = repmat(inter_stimuli, blocks_per_condition, 1);
                    correct = repmat(inter_correct, blocks_per_condition, 1);
                    inter_target = repmat(inter_is_target, blocks_per_condition, 1);
                    og_correct = correct;
                    is_target = zeros(blocks_per_condition * trials_per_block, 1);    
                end

                % randomize order

                %{
                idx = randperm(size(stimuli, 1))';
                stimuli = stimuli(idx, :);
                is_target = is_target(idx, :);
                correct = correct(idx, :);
                %}

                % get appropriate parameters depending on the condition
                
                curpar = zeros(1,6);
                curpar(5) = bias_for_task;
                curpar(6) = bias_for_attention;
                if OG_ONLY
                    curpar(1:4) = [1 0 1 0];
                else       
                    if FOCAL
                        if ~EMPHASIS
                            % focal, low emphasis
                            curpar(1:4) = focal_low_init_wm;
                        else
                            % focal, high emphasis
                            curpar(1:4) = focal_high_init_wm;
                        end
                    else
                        if ~EMPHASIS
                            % nonfocal, low emphasis
                            curpar(1:4) = nonfocal_low_init_wm;
                        else
                            % nonfocal, high emphasis
                            curpar(1:4) = nonfocal_high_init_wm;
                        end
                    end
                end                

                % initialize simulator
                sim = Simulator(curpar);            
                
                % PM instruction
                if FOCAL
                    if TARGETS == 6
                        sim.instruction({'tortoise', 'dog', 'cat', 'kiwi', 'panda', 'monkey'}, true);
                    else
                        assert(TARGETS == 1);
                        if exp_id == 5
                            sim.instruction({'tortoise'}, false);
                        else
                            sim.instruction({'tortoise'}, true);
                        end
                    end
                else
                    sim.instruction({'tor'}, true);
                end

                % simulate subjects
                for subject_id = 1:subjects_per_condition
                    [responses, RTs, act, acc, onsets, offsets, nets] = sim.trial(stimuli);

                    if exp_id == 1 || exp_id == 3 || exp_id == 5
                        % for experiment 1, each subject = 1 sample
                        [OG_RT, ~, OG_Hit, PM_RT, ~, PM_Hit, PM_miss_OG_hit] = getstats(sim, OG_ONLY, FOCAL, EMPHASIS, TARGETS, ...
                            responses, RTs, act, acc, onsets, offsets, ...
                            is_target, correct, og_correct, ...
                            false);

                        if exp_id == 5
                            % extra analysis for experiment 5
                            IT_TAR_RT = mean(RTs(logical(inter_target)));
                            IT_TAR_SEM = std(RTs(logical(inter_target))) / sqrt(length(RTs(logical(inter_target))));
                            IT_NONTAR_RT = mean(RTs(logical(~inter_target)));
                            IT_NONTAR_SEM = std(RTs(logical(~inter_target))) / sqrt(length(RTs(logical(~inter_target))));
                            fprintf(' bonus Exp 5: target RT = %.2f (%.2f), nontarget RT = %.2f (%.2f)\n', ...
                                IT_TAR_RT, IT_TAR_SEM, IT_NONTAR_RT, IT_NONTAR_SEM);
                            
                            tar_resp = responses(logical(inter_target));
                            tar_correct = correct(logical(inter_target));
                            IT_tar_hit = sum(strcmp(tar_resp, tar_correct)) / length(tar_correct) * 100;
                            fprintf('            : accuracy on targets = %.2f\n', IT_tar_hit);
                        end
                     
                        subject = [OG_ONLY, FOCAL, EMPHASIS, OG_RT, OG_Hit, PM_RT, PM_Hit, PM_miss_OG_hit, IT_TAR_RT, IT_NONTAR_RT, IT_tar_hit];
                        data = [data; subject];
                        subject_extra = {sim, OG_ONLY, FOCAL, EMPHASIS, TARGETS, responses, RTs, act, acc, onsets, offsets, nets};
                        extra = [extra; subject_extra];

                    elseif exp_id == 2
                        % for experiment 2, each block = 1 sample (i.e. 4
                        % samples per subject)
                        for block_id = 1:blocks_per_condition
                            block_start = (block_id - 1) * trials_per_block + 1;
                            block_end = block_id * trials_per_block;                    
                            [OG_RT, ~, OG_Hit, PM_RT, ~, PM_Hit, PM_miss_OG_hit] = ...
                                getstats(sim, OG_ONLY, FOCAL, EMPHASIS, TARGETS, ...
                                responses(block_start:block_end), RTs(block_start:block_end), [], [], [], [], ...
                                is_target(block_start:block_end), ...
                                correct(block_start:block_end), ...
                                og_correct(block_start:block_end), ...
                                false);

                            % put subject and block id's at the end to make it
                            % compatible with the data from experiment 1
                            block = [OG_ONLY, FOCAL, EMPHASIS, OG_RT, OG_Hit, PM_RT, PM_Hit, PM_miss_OG_hit, subject_id, block_id];
                            data = [data; block];
                        end
                    end
                    
                    % show picture of whole thing (for debugging)
                    %{
                    if ~OG_ONLY
                        getstats(sim, OG_ONLY, FOCAL, EMPHASIS, TARGETS, ...
                            responses, RTs, act, acc, onsets, offsets, ...
                            is_target, correct, og_correct, ...
                            true);
                    end
                    %}
                end
            
                
                
                
            end
        end
    end
end
