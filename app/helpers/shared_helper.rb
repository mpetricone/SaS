module SharedHelper
    PathBase = "_path"
    PathSeperator = '_'
    def constructPath model, type=nil
        base = model.class.model_name.to_s.underscore
        if type=='index' || type==nil
          path =base+'s'
        else
           path = type+PathSeperator+base
        end
        return path+PathBase
    end

end
