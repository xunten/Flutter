<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use App\Models\Language;

class CreateLanguagesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('languages', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('language');
            $table->string('lang_code');
            $table->integer('status')->default(1);
            $table->timestamp('created_at')->default(DB::raw('CURRENT_TIMESTAMP'));
            $table->timestamp('updated_at')->default(DB::raw('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'));
        });

        $data =  [
            ['language' => 'English', 'lang_code' => 'en',  'status' => '1'],
            ['language' => 'हिन्दी',     'lang_code' => 'hi',  'status' => '0'],
            ['language' => 'ગુજરાતી',    'lang_code' => 'guj', 'status' => '0'],
            ['language' => 'عربي',    'lang_code' => 'ar',  'status' => '0'],
        ];

        Language::insert($data);
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('languages');
    }
}
