classdef modelAnalyze < handle
    %modelAnalyze Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %Handle to other Classes
        controllerAnalyzeHandle
    end
    
    properties
        FileNamesRGB
        PathNames
        PicRGB
        handlePicRGB
        PicBW
        PicPlaneGreen
        PicPlaneBlue
        PicPlaneRed
        PicPlaneFarRed
        PicPRGBPlanes 
        
        FiberInfo = {};
        BoundarieMat
        LabelMat
        PicInvertBW
        handleInfoAxes
        oldValueMinArea;
        AnalyzeMode;
    end
    
    properties(SetObservable)
        AreaActive
        MinAreaPixel
        MaxAreaPixel
        
        AspectRatioActive
        MinAspectRatio
        MaxAspectRatio
        
        RoundnessActive
        MinRoundness
        
        ColorDistanceActive
        MinColorDistance
        
        ColorValueActive
        ColorValue
        
        CalculationRunning;
        
        InfoMessage;
        
        Stats
    end
    
    methods
        
        function obj = modelAnalyze()
            % Don't execute showFiberInformation befor analyze was running
            obj.CalculationRunning = true;
            
            obj.FiberInfo{1} = '-';
            obj.FiberInfo{2} = '-';
            obj.FiberInfo{3} = '-';
            obj.FiberInfo{4} = '-';
            obj.FiberInfo{5} = '-';
            obj.FiberInfo{6} = '-';
            obj.FiberInfo{7} = '-';
            obj.FiberInfo{8} = [];
        end
        
        function startAnalysze(obj)
            obj.CalculationRunning = true;
            obj.InfoMessage = '- start analyzing';
            pause(0.01);

            if isempty(obj.Stats) || ~isequal(obj.oldValueMinArea,obj.MinAreaPixel)
                % Calculation runs the first Time or changes at binary
                % mask by user
            obj.labelingObjects();
            
            obj.calculateRoundness();
            
            obj.calculateAspectRatio();
            
            obj.calculatingFiberColor();
            else
            obj.InfoMessage = '   - object labeling alreaey done'; 
            obj.InfoMessage = '   - calculating Roundness alreaey done';
            obj.InfoMessage = '   - calculating Aspect Ratio alreaey done';
            obj.InfoMessage = '   - calculating Fiber Color alreaey done';
            end
            obj.specifyFiberType();
            
            obj.plotBoundaries();
            
            
            obj.InfoMessage = '- analyzing completed';
            
            obj.CalculationRunning = false;
            
        end
        
        function labelingObjects(obj)
            obj.InfoMessage = '   - labeling objects...';
            
            
          
            obj.PicInvertBW = ~obj.PicBW;
            
            % Fill holes in the binary image
            obj.PicInvertBW = imfill(obj.PicInvertBW,8,'holes');
            
            if obj.AreaActive
            % Remove all objects that are smaller than the MinArea
            obj.InfoMessage = ['      - remove objects smaller than ' num2str(obj.MinAreaPixel) ' pixels'];
            obj.oldValueMinArea = obj.MinAreaPixel;
            
            obj.PicInvertBW = bwareaopen(obj.PicInvertBW,obj.MinAreaPixel,4);
            else
                % Remove single pixels
                obj.PicInvertBW = bwareaopen(obj.PicInvertBW,1,4);
            end
            
            [obj.BoundarieMat,obj.LabelMat] = bwboundaries(obj.PicInvertBW,4,'noholes');
            
            %             CC = bwconncomp(BW);
            obj.InfoMessage = '      - measure properties of image objects';
            
            obj.Stats = regionprops('struct',obj.LabelMat,'Area','Perimeter','Centroid','BoundingBox','MajorAxisLength','MinorAxisLength','Solidity');
            
            % Add Field Boundarie to Stats Struct ans set all Values to
            % zero
            [obj.Stats(:).Boundarie] = deal(0);
            
            %obj.Labels = labelmatrix(CC);
            obj.InfoMessage = '      - save boundaries';
            
            for i=1:1:length(obj.Stats)
                obj.Stats(i).Boundarie = mat2cell(obj.BoundarieMat{i,1},size(obj.BoundarieMat{i,1},1),size(obj.BoundarieMat{i,1},2));
            end
            
            obj.InfoMessage = ['      - ' num2str(length(obj.Stats)) ' objects was found'];
            
            
        end
        
        function calculateRoundness(obj)
            obj.InfoMessage = '   - calculating roundness...';
            
            % Add Field Roundness to Stats Struct ans set all Values to
            % zero
            [obj.Stats(:).Roundness] = deal(0);
            for i=1:1:length(obj.Stats)
%                 obj.Stats(i).Roundness = obj.Stats(i).MinorAxisLength / obj.Stats(i).MajorAxisLength ;
                A_Cmax = obj.Stats(i).MajorAxisLength^2 * pi / 4;
                A_Cmin = obj.Stats(i).MinorAxisLength^2 * pi / 4;
                A_Fiber = obj.Stats(i).Area;
                Ratiomax = A_Fiber/A_Cmax;
                Ratiomin = A_Fiber/A_Cmin;
                obj.Stats(i).Roundness = 1 - (abs( Ratiomax -  Ratiomin))/max([Ratiomax  Ratiomin]);
            end
        end
        
        function calculateAspectRatio(obj)
            obj.InfoMessage = '   - calculating aspect ratio...';
            % Add Field AspectRation to Stats Struct and
            % set all values to zero
            [obj.Stats(:).AspectRatio] = deal(0); %Hue-channel of HSV colormodel
            
            nObjects = length(obj.Stats);
            
            for i=1:1:nObjects
                obj.Stats(i).AspectRatio = obj.Stats(i).MajorAxisLength/obj.Stats(i).MinorAxisLength;
            end
            
        end
        
        function calculatingFiberColor(obj)
            obj.InfoMessage = '   - calculating fiber color...';
            
           
            
            % Add Field ColorValue and ColorValueNorm  to Stats Struct ans
            % set all values to zero
            [obj.Stats(:).ColorHue] = deal(0); %Hue-channel of HSV colormodel
            [obj.Stats(:).ColorValue] = deal(0); %Value-channel of HSV colormodel
            [obj.Stats(:).ColorRed] = deal(0);
            [obj.Stats(:).ColorGreen] = deal(0);
            [obj.Stats(:).ColorBlue] = deal(0);
            [obj.Stats(:).ColorFarRed] = deal(0);
            [obj.Stats(:).ColorRatioBlueRed] = deal(0);
            [obj.Stats(:).ColorDistBlueRed] = deal(0);
            
            nObjects = length(obj.Stats);
            
            PicRGB_HSV = rgb2hsv(obj.PicRGB);
            PicRGB_H = PicRGB_HSV(:,:,1); % H-channel of HSV pic
            PicRGB_V = PicRGB_HSV(:,:,3); % V-channel of HSV pic
            
            for i=1:1:nObjects
                
              meanColorH =   mean( PicRGB_H(obj.LabelMat == i) );
              meanColorV =   mean( PicRGB_V(obj.LabelMat == i) );
              meanRed = mean( obj.PicPlaneRed(obj.LabelMat == i) );
              meanFarRed = mean( obj.PicPlaneFarRed(obj.LabelMat == i) );
              meanBlue = mean( obj.PicPlaneBlue(obj.LabelMat == i) );
              meanGreen = mean( obj.PicPlaneGreen(obj.LabelMat == i) );
              
              maxC = max([meanRed meanBlue]);
              
              if maxC == 0
                  % Dividing by 0 is uncool
                  maxC = 1;
              end
              
              obj.Stats(i).ColorRed = meanRed;
              obj.Stats(i).ColorGreen = meanGreen;
              obj.Stats(i).ColorBlue = meanBlue;
              obj.Stats(i).ColorFarRed = meanFarRed;
              obj.Stats(i).ColorHue = meanColorH;
              obj.Stats(i).ColorValue = meanColorV;
              obj.Stats(i).ColorDistBlueRed = (meanBlue - meanRed)/maxC;
              obj.Stats(i).ColorRatioBlueRed = meanBlue/meanRed;
              
              percent =   i/nObjects;
              workbar(percent,'Please Wait...calculating fiber color','Fiber-Color');
           
            end
            
        end
        
        function plotBoundaries(obj)
            obj.InfoMessage = '   - plot boundaries...';
            
            
            %             obj.waitb = waitbar(0,'Please Wait...Calculating Boundaries');
            axesh = obj.handlePicRGB.Parent;
            %             axes(axesh);
            %             axesh.Children = [];
            
            % Find old Boundarie Objects and delete them
            hBounds = findobj(axesh,'Type','hggroup');
            delete(hBounds);
            
            nObjects = length(obj.Stats);
            
            axes(axesh)
            for i=1:1:nObjects
                
                switch obj.Stats(i).FiberType
                    case 0
                        Color = 'w';
                    case 1
                        Color = 'b';
                    case 2
                        Color = 'r';
                    case 3
                        Color = 'm';
                    otherwise
                        Color = 'b';
                end
 
                hold on
                
                htemp = visboundaries(axesh,obj.Stats(i).Boundarie,'Color',Color,'LineWidth',0.1);
                % Tag every Boundarie Line Object with his own Label number
                % to find them later for manipualtion
                set(htemp,'Tag',['boundLabel ' num2str(i)])
                
                percent =   i/nObjects;
                if i == 1
                    % get workbar in foreground
                    pause(0.1)
                end
                workbar(percent,'Please Wait...ploting Boundaries','ploting boundaries');
            end

        end
        
        function specifyFiberType(obj)

            obj.InfoMessage = '   - specifying fiber type';
            
            nObjects = length(obj.Stats);
            
            fibtype1 = 0; % (blue)
            fibtype2 = 0; % (red)
            fibtype3 = 0; % (magenta)
            fibtype0 = 0; % (white)
            
            % Add Field FiberType to Stats Struct and set all values to
            % zero
            [obj.Stats(:).FiberType] = deal(0);
            
            if obj.AnalyzeMode == 1 % Color-Based classification
            
            for i=1:1:nObjects
%                 
                if obj.AreaActive && ( obj.Stats(i).Area > obj.MaxAreaPixel )
                    
                    % Object Area is to big. FiberType 0: No Fiber (white)
                    obj.Stats(i).FiberType = 0;
                    fibtype0 = fibtype0+1;
                    
                elseif obj.AspectRatioActive && ( obj.Stats(i).AspectRatio < obj.MinAspectRatio || ...
                        obj.Stats(i).AspectRatio > obj.MaxAspectRatio )
                    
                    % ApsectRatio is to small or to great.
                    % FiberType 0: No Fiber (white)
                    obj.Stats(i).FiberType = 0;
                    fibtype0 = fibtype0+1;
                    
                elseif obj.RoundnessActive && ( obj.Stats(i).Roundness < obj.MinRoundness )
                    
                    % Object Roundness is to small. FiberType 0: No Fiber (white))
                    obj.Stats(i).FiberType = 0;
                    fibtype0 = fibtype0+1;
                    
                elseif obj.ColorValueActive && ( obj.Stats(i).ColorValue < obj.ColorValue )
                    
                    % Color Value (V-Channel of HSV color room) is to samll
                    % FiberType 0: No Fiber (white)
                    obj.Stats(i).FiberType = 0;
                    fibtype0 = fibtype0+1;
                    
                elseif obj.ColorDistanceActive && ( abs(obj.Stats(i).ColorDistBlueRed) < obj.MinColorDistance )
                    
                    % Absolute Value of color distance between Blue and Red is to small.
                    % FiberType 3 (magenta): Fiber between Typ 1 and Typ 2
                    obj.Stats(i).FiberType = 3;
                    fibtype3 = fibtype3+1;
                    
                elseif obj.Stats(i).ColorDistBlueRed > 0 
                    
                    % Color distance is smaller than 0. Negative values
                    % means Red Color is greater. Fiber Type 1 (blue)
                    obj.Stats(i).FiberType = 1;
                    fibtype1 = fibtype1+1;
                    
                elseif obj.Stats(i).ColorDistBlueRed < 0 

                % Color distance is greater than 0. Positive values
                % means Blue Color is greater. FIber Type 2 (red)
                obj.Stats(i).FiberType = 2;
                fibtype2 = fibtype2+1;
                
                else
                    %Error Code
                    obj.Stats(i).FiberType = 'Error';
                end

                percent =   i/nObjects;
                workbar(percent,'Please Wait...specifing Fiber-Type','Fiber-Type');
                
            end
            
            elseif obj.AnalyzeMode == 2 | obj.AnalyzeMode == 3 % Cluster-Based classification
                % Search for 2 or 3 Clusters 
                NoOfClusters = obj.AnalyzeMode;
                
                Data(:,1) = [obj.Stats.ColorBlue];
                Data(:,2) = [obj.Stats.ColorRed];
%                 Data(:,3) = [obj.Stats.ColorHue];
%                 Data(:,4) = [obj.Stats.ColorValue];
                
                [idx,C] = kmeans(Data,NoOfClusters,'Distance','cityblock');
                % C contains the cluster focus points.
                % C(1,1) meanBlue of cluster 1 focus point 
                % C(1,2) meanRed of cluster 1 focus point
                % C(2,1) meanBlue of cluster 2 focus point 
                % C(2,2) meanRed of cluster 2 focus point
                % and so on.
                
                % Find ClusterPoint with higest Blue Value:
                [rowB colB] = find( C == max(C(:,1)) );
                
                % Find ClusterPoint with higest Red Value:
                [rowR colR] = find( C == max(C(:,2)) );
                
                idx = idx*10;
                
                idx(idx==rowB*10) = 1; % FiberType 1
                idx(idx==rowR*10) = 2; % FiberType 2
                idx(idx>9) = 3; % Fibertype 3
                
                 for i=1:1:nObjects
                     
                     if obj.AreaActive && ( obj.Stats(i).Area > obj.MaxAreaPixel )
                    
                    % Object Area is to big. FiberType 0: No Fiber (white)
                    obj.Stats(i).FiberType = 0;
                    fibtype0 = fibtype0+1;
                    
                     elseif obj.RoundnessActive && ( obj.Stats(i).Roundness < obj.MinRoundness )
                    
                    % Object Roundness is to small. FiberType 0: No Fiber (white))
                    obj.Stats(i).FiberType = 0;
                    fibtype0 = fibtype0+1;
                    
                    elseif obj.ColorValueActive && ( obj.Stats(i).ColorValue < obj.ColorValue )
                    
                    % Color Value (V-Channel of HSV color room) is to samll
                    % FiberType 0: No Fiber (white)
                    obj.Stats(i).FiberType = 0;
                    fibtype0 = fibtype0+1;
                    
                    elseif idx(i) == 1
                        
                    % Cluster Type 1    
                    obj.Stats(i).FiberType = 1;
                    fibtype1 = fibtype1+1;
                    
                    elseif idx(i) == 2
                        
                    % Cluster Type 1    
                    obj.Stats(i).FiberType = 2;
                    fibtype2 = fibtype2+1;
                    
                    elseif idx(i) == 3
                        
                    % Cluster Type 1    
                    obj.Stats(i).FiberType = 3;
                    fibtype3 = fibtype3+1;
                     end
                     
                 end
                
            end
            
            obj.InfoMessage = ['      - ' num2str(nObjects) ' fibers were found'];
            
            obj.InfoMessage = ['         - ' num2str(fibtype1) ' Type-1 fibers were found (blue)'];
            
            obj.InfoMessage = ['         - ' num2str(fibtype2) ' Type-2 fibers were found (red)'];
            
            obj.InfoMessage = ['         - ' num2str(fibtype3) ' Type-3 fibers were found (magenta)'];
            
            obj.InfoMessage = ['         - ' num2str(fibtype0) ' Type-0 fibers were found (white)'];
            
        end
        
        function Info = manipulateFiberShowInfo(obj,Label,Pos)
            
            axesh = obj.handlePicRGB.Parent;
            
            PosBoundingBox = obj.Stats(Label).BoundingBox;
%             axes(axesh)
            rectLine = rectangle('Position',PosBoundingBox,'EdgeColor','y','LineWidth',2);
            set(rectLine,'Tag','highlightBox')
            
            % get fibertype informatoin at the selected pos and
            % return the Info cell array
            Info = obj.showFiberInfo(Pos);
            
        end
        
        function manipulateFiberOK(obj,newFiberType,labelNo)
            
            if newFiberType == 4
                % FIber-Type 0 (no Fiber) has the Value 4 in the pushup
                % menu object
                newFiberType = 0;
            end
            
            oldFiberType = obj.Stats(labelNo).FiberType;
            
            if newFiberType == oldFiberType
                % Fiber Type hasn't changed
            else
                % Fiber Type has changed
                obj.Stats(labelNo).FiberType = newFiberType;
                axesh = obj.handlePicRGB.Parent;
                
                switch obj.Stats(labelNo).FiberType
                    case 0
                        Color = 'w';
                    case 1
                        Color = 'b';
                    case 2
                        Color = 'r';
                    case 3
                        Color = 'm';
                    otherwise
                end
                
                obj.Stats(labelNo).FiberType = newFiberType;
                
                % find old boundarie and delete them
                htemp = findobj('Tag',['boundLabel ' num2str(labelNo)]);
                delete(htemp);
                
                % plot new boundarie
                htemp = visboundaries(axesh,obj.Stats(labelNo).Boundarie,'Color',Color);
                set(htemp,'Tag',['boundLabel ' num2str(labelNo)])
                obj.InfoMessage = ['   - Fiber-Type object No. ' num2str(labelNo) ' changed by user'];
            end
            
        end
        
        function Data = sendDataToController(obj)
            
            Data{1} = obj.FileNamesRGB;
            Data{2} = obj.PathNames;
            Data{3} = obj.PicRGB;
            Data{4} = obj.Stats;
            Data{5} = obj.LabelMat;
            % Analyze Paraeter
            Data{6} = obj.AnalyzeMode;
            Data{7} = obj.AreaActive;
            Data{8} = obj.MinAreaPixel;
            Data{9} = obj.MaxAreaPixel;
            
            Data{10} = obj.AspectRatioActive;
            Data{11} = obj.MinAspectRatio;
            Data{12} = obj.MaxAspectRatio;
            
            Data{13} = obj.RoundnessActive;
            Data{14} = obj.MinRoundness;
            
            Data{15} = obj.ColorDistanceActive;
            Data{16} = obj.MinColorDistance;
            
            Data{17} = obj.ColorValueActive;
            Data{18} = obj.ColorValue;
            
        end
        
        function Info = showFiberInfo(obj,Pos)
            
            PosOut = obj.checkPosition(Pos);
           
            
            if ~obj.CalculationRunning &&...
                    ( ~isnan(PosOut(1)) && ~isnan(PosOut(2)) ) &&...
                    ~isempty(obj.Stats)
                
                 Label = obj.LabelMat(PosOut(2),PosOut(1));
                
                if (Label > 0) 
                    BoundBox =   round(obj.Stats(Label).BoundingBox);
                    
                    [y origPos]= imcrop(obj.PicRGB,[BoundBox(1) BoundBox(2) BoundBox(3) BoundBox(4)]);
                    Bound = obj.Stats(Label).Boundarie;
                    Bound{1,1}(:,1) = Bound{1,1}(:,1)-origPos(2);
                    Bound{1,1}(:,2) = Bound{1,1}(:,2)-origPos(1);
                    
                    obj.FiberInfo{1} = num2str(Label);
                    obj.FiberInfo{2} = num2str(obj.Stats(Label).Area);
                    obj.FiberInfo{3} = num2str(obj.Stats(Label).AspectRatio);
                    obj.FiberInfo{4} = num2str(obj.Stats(Label).Roundness);
                    obj.FiberInfo{5} = num2str(obj.Stats(Label).ColorDistBlueRed);
                    obj.FiberInfo{6} = num2str(obj.Stats(Label).ColorValue);
                    obj.FiberInfo{7} = num2str(obj.Stats(Label).FiberType);
                    
                    obj.FiberInfo{8} = y;
                    obj.FiberInfo{9} = Bound;
                    Info = obj.FiberInfo;
                    %             Info{5} = Bound;
                else
                    Info = obj.FiberInfo;
                    %             Info{5} = [];
                end
                
            else
                obj.FiberInfo{1} = ' - ';
                obj.FiberInfo{2} = ' - ';
                obj.FiberInfo{3} = ' - ';
                obj.FiberInfo{4} = ' - ';
                obj.FiberInfo{5} = ' - ';
                obj.FiberInfo{6} = ' - ';
                obj.FiberInfo{7} = ' - ';
                obj.FiberInfo{8} = [];
                obj.FiberInfo{9} = [];
                Info = obj.FiberInfo;

            end
        end
        
        function PosOut = checkPosition(obj,PosIn)
            PosX = round(PosIn(1,1));
            PosY = round(PosIn(1,2));
            
            if PosX < 1
                PosX = NaN;
            end
            
            if PosY < 1
                PosY = NaN;
            end
            
            if PosX > size(obj.PicRGB,2)
                PosX = NaN;
            end
            
            if PosY > size(obj.PicRGB,1)
                PosY = NaN;
            end
            
            PosOut = [PosX PosY];
        end
        
        function delete(obj)
            
        end
        
    end
    
end

