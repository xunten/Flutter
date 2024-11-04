<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateOneToOneChallengeTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('one_to_one_challenge', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('room_id');
            $table->integer('category_id');
            $table->string('name');
            $table->integer('c_user_id');
            $table->integer('j_user_id')->default(0);
            $table->datetime('start_date');
            $table->datetime('end_date');
            $table->string('total_question');
            $table->integer('is_paid')->comment('0- No , 1- Yes');
            $table->string('price')->default('0');
            $table->integer('is_full')->default(0);
            $table->string('question_ids');
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
        Schema::dropIfExists('one_to_one_challenge');
    }
}
