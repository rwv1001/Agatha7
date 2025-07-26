include EditHelper

class AgathaFilesController < ApplicationController
  def edit
    @table_name = params[:table_name];
    @id = params[:id];

    @short_name = session[:search_ctls][@table_name].GetShortField(@id );

    edit_helper(@table_name,["agatha_data_file_name", "agatha_data_content_type", "agatha_data_file_size", "agatha_data_updated_at" ]);
  end

  def file_upload
    x = 2;
    agatha_params_file = params[:agatha_file]
  #  agatha_file = params[:agatha_file];
    id = params[:id];
   agatha_file_obj = AgathaFile.find(id);
   

  agatha_file_obj.agatha_data = agatha_params_file[:agatha_data];
 
    agatha_file_obj.save;
    @table_name = params[:table_name];
    edit_helper(@table_name,["agatha_data_file_name", "agatha_data_content_type", "agatha_data_file_size", "agatha_data_updated_at" ]);

  end

  



  def win_load

    win_load_helper();

  end

  def win_unload
    win_unload_helper();



  end

  def updater
    update_helper();

  end



end
