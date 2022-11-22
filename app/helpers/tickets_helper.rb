module TicketsHelper
    def configure_params
        parammod = Hash.new;
        if params.has_key? :search_solved
            parammod[:search_solved] = true
        else
            parammod[:search_solved] = false
        end
        parammod[:search_dates] = false;
        if params.has_key? :search_dates
            parammod[:search_dates] = true;
            parammod[:date_start] = params[:date_params][:date_start];
            parammod[:date_end] = params[:date_params][:date_end];
        end
        return parammod;
    end
end
