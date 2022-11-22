module ShowHelper

	def render_show_title var_title, var_edit, var_return
		render partial: 'shared/show_page_title', locals: {title: var_title, edit_path: var_edit, return_path: var_return}
	end

	def renderShowValues var_model, var_title, var_values, var_sub_values=nil
		render partial: 'shared/show_values', locals: {model: var_model, title: var_title, values: var_values, sub_values: var_sub_values }
	end
end
