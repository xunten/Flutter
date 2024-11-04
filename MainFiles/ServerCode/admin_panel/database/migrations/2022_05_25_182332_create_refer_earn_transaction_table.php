<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateReferEarnTransactionTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('refer_earn_transaction', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->integer('parent_user_id');
            $table->integer('child_user_id');
            $table->string('reference_code');
            $table->float('parent_user_referred_point');
            $table->float('child_user_earned_point');
            $table->integer('earn_point_type');
            $table->date('refered_date')->default(DB::raw('CURRENT_TIMESTAMP'));
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
        Schema::dropIfExists('refer_earn_transaction');
    }
}
