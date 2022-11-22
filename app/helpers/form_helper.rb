module FormHelper

	def render_form_title title
		render partial: 'shared/form_page_title', locals: { title: title }
	end

	def render_actions(form_val,cancel_val)
		render partial: 'shared/form_actions', locals: { form: form_val, cancel: cancel_val }
	end

	def render_field(form_val, field_label_val, field_val, it_val, ext_param_vals=nil, options_val={}, html_options_val={})
		render( partial: 'shared/form_field', locals: {form: form_val, field_label: field_label_val, field: field_val, it: it_val, ext_params: ext_param_vals, options:options_val, html_options: html_options_val})
	end

	def render_sub_address_extra(form_val, mm_val, mm_title, sm_val, sm_title, extra_field_array)
		render partial: 'shared/sub_address_form',
			locals: {form: form_val, main_model: mm_val, main_title: mm_title, sub_model: sm_val, sub_title: sm_title, extra_fields: extra_field_array}
	end

	def render_sub_address(form_val, mm_val, mm_title, sm_val, sm_title)
		render partial: 'shared/sub_address_form',
			locals: {form: form_val, main_model: mm_val, main_title: mm_title, sub_model: sm_val, sub_title: sm_title}
	end

	def render_extra_fields(form, extra_field_array)
		ret = ""
		extra_field_array.each do |f|
			ret << render_field(form, f[:label],f[:name], f[:type] )
		end

		return ret.html_safe
	end

	def render_field_group(form_val,main_title_var, field_array)
		render partial: 'shared/form_group', locals: { form: form_val, main_title: main_title_var, fields: field_array }
	end

	def render_field_array(form, field_array)
		ret = ""
		field_array.each do |f|
			if not f.has_key?(:options)
				f[:options]={ }
			end

			if not f.has_key?(:html_options)
				f[:html_options]={}
			end

			if f.has_key?(:search) # this is a search field
				ret << render_search_field(f)
			else
				ret << render_field(form, f[:label], f[:name], f[:type], f[:ext_params], f[:options], f[:html_options])
			end

		end

		return ret.html_safe
	end

	def render_search_field(f)
		render partial: 'shared/search', locals: { search_id: f[:search_id], search_name: f[:search_name] }
	end

	def render_fields_for(form_val, title_val, model_val, fields_val)
		render partial: 'shared/fields_for_form', locals: { form: form_val,title: title_val,  model: model_val,fields: fields_val }
	end

	def render_address_options(form)
		render_field_group form, t(:label_address_options), [
			{label: :delivery, name: :delivery, type: :check_box},
			{label: :invoice, name: :invoice, type: :check_box}]
	end

	def render_address_form form
		render_field_group form, Address.model_name.human, [
			{label: :street1, name: :street1, type: :text_field},
			{label: :street2, name: :street2, type: :text_field},
			{label: :city, name: :city, type: :text_field},
			{label: :postal_code, name: :postal_code, type: :text_field},
			{label: :state, name: :state, type: :text_field},
			{label: :country, name: :country, type: :text_field},
			{label: :status, name: :status, type: :text_field}]
	end

	def render_fields_for_address form
		render_fields_for form, Address.model_name.human, :address, [
			{label: :street1, name: :street1, type: :text_field},
			{label: :street2, name: :street2, type: :text_field},
			{label: :city, name: :city, type: :text_field},
			{label: :postal_code, name: :postal_code, type: :text_field},
			{label: :state, name: :state, type: :text_field},
			{label: :country, name: :country, type: :text_field},
			{label: :status, name: :status, type: :text_field}]
	end
end
