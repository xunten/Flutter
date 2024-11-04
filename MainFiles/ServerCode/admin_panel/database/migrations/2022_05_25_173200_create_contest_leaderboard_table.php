<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateContestLeaderboardTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('contest_leaderboard', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->integer('user_id');
            $table->integer('level_id');
            $table->integer('question_level_master_id');
            $table->integer('category_id');
            $table->string('total_questions');
            $table->string('questions_attended');
            $table->string('correct_answers');
            $table->float('score', 8, 2)->default(0.00);
            $table->date('date')->default(DB::raw('CURRENT_TIMESTAMP'));
            $table->integer('is_unlock');
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
        Schema::dropIfExists('contest_leaderboard');
    }
}
