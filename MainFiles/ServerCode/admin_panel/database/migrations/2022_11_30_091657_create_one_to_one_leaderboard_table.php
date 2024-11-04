<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateOneToOneLeaderboardTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('one_to_one_leaderboard', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('room_id');
            $table->string('winning_amount')->default('0');
            $table->integer('w_user_id');
            $table->integer('l_user_id');
            $table->integer('status')->comment('0- Draw , 1- Completed , 2- Not Completed');
            $table->date('date')->default(DB::raw('CURRENT_TIMESTAMP'));
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
        Schema::dropIfExists('one_to_one_leaderboard');
    }
}
