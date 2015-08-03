function st = spanningtree(g,varargin)
% SPANNINGTREE finds spanning tree of the graph
%
% Synopsis
%   ST = SPANNINGTREE(GRAPH,USERPARAMPOSITION)
%
% Description
%    GRAPH     - graph with costs between nodes
%              - type inf when edge between two edges does not exist
%    USERPARAMPOSITION - position in UserParam of Nodes where number
%                representative color is saved. This parameter is
%                optional. Default is 1.
%    ST        - matrix which represetnts minimals body of the graph
%
%  See also GRAPH/GRAPH, GRAPH/DIJKSTRA.


% Author: Premysl Sucha <suchap@fel.cvut.cz>
% Originator: Michal Kutil <kutilm@fel.cvut.cz>
% Originator: Premysl Sucha <suchap@fel.cvut.cz>
% Project Responsible: Zdenek Hanzalek
% Department of Control Engineering
% FEE CTU in Prague, Czech Republic
% Copyright (c) 2004 - 2009 
% $Revision: 2896 $  $Date:: 2009-03-18 12:20:12 +0100 #$


% This file is part of TORSCHE Scheduling Toolbox for Matlab.
% TORSCHE Scheduling Toolbox for Matlab can be used, copied 
% and modified under the next licenses
%
% - GPL - GNU General Public License
%
% - and other licenses added by project originators or responsible
%
% Code can be modified and re-distributed under any combination
% of the above listed licenses. If a contributor does not agree
% with some of the licenses, he/she can delete appropriate line.
% If you delete all lines, you are not allowed to distribute 
% source code and/or binaries utilizing code.
%
% --------------------------------------------------------------
%                  GNU General Public License  
%
% TORSCHE Scheduling Toolbox for Matlab is free software;
% you can redistribute it and/or modify it under the terms of the
% GNU General Public License as published by the Free Software
% Foundation; either version 2 of the License, or (at your option)
% any later version.
% 
% TORSCHE Scheduling Toolbox for Matlab is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY;
% without even the implied warranty of MERCHANTABILITY or 
% FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with TORSCHE Scheduling Toolbox for Matlab; if not, write
% to the Free Software Foundation, Inc., 59 Temple Place,
% Suite 330, Boston, MA 02111-1307 USA



    if nargin > 1
        userParamPos = varargin{1};
    else
        userParamPos = 1;
    end

    M = edge2param(g,userParamPos);     % matrix of edges weights
    n = size(M,1);                      % count of nodes
    Mst = inf*ones(n);                  % matrix spanningtree

    L = 1:n;                            % set of subgraphs (each node is one supgraph at start)

    while 1,
        [minWeight,index] = min(M(:));  % edge with minimal weight

        if minWeight == inf,            % all edges were removed
            break;
        end;

        i = mod(index,n);               % which row we are working with (FROM node)
        if i == 0,  i = n;  end;
        j = ceil(index/n);              % which column we are working with (TO node)

        L(L==L(j)) = L(i);              % subgraph L(j) is added to subgraph L(i)
        M(L==L(i),L==L(i)) = inf;       % edges in subgraph L(i) are removed

        Mst(index) = minWeight;         % edge is added to spanningtree
    end;

    st = graph(Mst);
    
    % TODO directed2undirected
    
%end .. @graph/spanningtree

