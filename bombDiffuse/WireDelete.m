function WireDelete (wireColor,rWire,bWire,gWire,yWire,cWire,kWire)
% Deletes line plot based on string
% Inputs:    wireColor -- color of wire
%            rWire -- red wire plot
%            bWire -- blue wire plot
%            gWire -- green wire plot
%            yWire -- yellow wire plot
%            cWire -- cyan wire plot
%            kWire -- black wire plot

if strcmpi(wireColor,'red') == 1
    delete(rWire);
elseif strcmpi(wireColor,'blue') == 1
    delete(bWire);
elseif strcmpi(wireColor,'green') == 1
    delete(gWire);
elseif strcmpi(wireColor,'yellow') == 1
    delete(yWire);
elseif strcmpi(wireColor,'cyan') == 1
    delete(cWire);
elseif strcmpi(wireColor,'black') == 1
    delete(kWire);
end

end