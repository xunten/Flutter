<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateContestMasterTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('contest_master', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('name');
            $table->datetime('start_date');
            $table->datetime('end_date');
            $table->integer('type')->default(0);
            $table->integer('level_id');
            $table->string('image');
            $table->string('price');
            $table->integer('no_of_user');
            $table->integer('no_of_user_prize');
            $table->integer('no_of_rank');
            $table->integer('total_prize');
            $table->text('prize_json');
            $table->integer('status')->default(1);
            $table->timestamp('created_at')->default(DB::raw('CURRENT_TIMESTAMP'));
            $table->timestamp('updated_at')->default(DB::raw('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'));
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('contest_master');
    }
}
