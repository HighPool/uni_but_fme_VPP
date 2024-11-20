clear;clc;clf;
load cv_06a.mat;
%load cv_06b.mat;
problem.start_node = 1;
end_node = problem.end_node;

node_list = problem.node_list;
node_neighbors = problem.node_neighbors;
neighbors_distance = problem.neighbors_distance;
nr_nodes = length(node_list);
M = problem.M;
%imshow(M,'InitialMagnification',1200);

OPEN = [problem.start_node];
LABEL = Inf*ones(nr_nodes,1);
LABEL(problem.start_node) = 0;
UPPER = Inf;
PARENT = Inf*ones(nr_nodes,1);
PARENT(problem.start_node) = problem.start_node;

iter = 0;


h = zeros(nr_nodes,1);
for i=1:nr_nodes
    h(i) = norm(node_list(i,:) - node_list(end_node,:),1);
end
tic
while ~isempty(OPEN)
    iter = iter + 1;
    %BFS
    i = OPEN(1); OPEN(1) = [];
    %Dijkstra
    %[~,id] = min(LABEL(OPEN));
    %i = OPEN(id); OPEN(id) = [];
    %Dijkstra + A*
    %[~,id] = min(LABEL(OPEN) + h(OPEN));
    %i = OPEN(id); OPEN(id) = [];
    nr_child = length(node_neighbors{i});
    for j = 1:nr_child
        child_idx = node_neighbors{i}(j);
        if LABEL(i) + neighbors_distance{i}(j) < min(LABEL(child_idx), UPPER)
        %if LABEL(i) + neighbors_distance{i}(j) < LABEL(child_idx) && ...
         %   LABEL(i) + neighbors_distance{i}(j) + h(child_idx) < UPPER

            LABEL(child_idx) = LABEL(i) + neighbors_distance{i}(j);
            PARENT(child_idx) = i;
            if child_idx ~= end_node && ~ismember(child_idx,OPEN)
                OPEN(end+1) = child_idx;
                x = node_list(child_idx,1);
                y = node_list(child_idx,2);
                M(x,y,1) = 0.9;
                M(x,y,2) = 0.7;
                M(x,y,3) = 0;
            elseif child_idx == end_node 
                UPPER = LABEL(child_idx);
            end
        end
    end
    % if mod(iter,1000) == 0
    %     pause(0.01);
    %     imshow(M,'InitialMagnification',1200); 
    %     pause(0.01);
    % end
end

if UPPER < Inf
    PATH = [end_node];
    cur_parent = PARENT(end_node);
    while cur_parent ~= problem.start_node
        PATH = [cur_parent,PATH];
        x = node_list(cur_parent,1);
        y = node_list(cur_parent,2);
        M(x,y,1) = 1;
        M(x,y,2) = 0;
        M(x,y,3) = 0;
        cur_parent = PARENT(cur_parent);
    end
end
toc
imshow(M,'InitialMagnification',1200);








