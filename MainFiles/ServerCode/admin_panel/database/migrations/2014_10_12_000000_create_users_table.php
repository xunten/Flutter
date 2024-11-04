<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateUsersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('users', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('fullname');
            $table->text('username');            
            $table->string('email');
            $table->string('password');
            $table->string('mobile_number');
            $table->string('profile_img');
            $table->integer('type')->comment('1- normal , 2- facebook, 3- login with otp')->default(1);
            $table->text('instagram_url')->nullable();
            $table->text('facebook_url')->nullable();
            $table->text('twitter_url')->nullable();
            $table->text('biodata')->nullable();
            $table->text('address')->nullable();
            $table->string('reference_code');
            $table->string('parent_reference_code')->nullable();
            $table->float('pratice_quiz_score')->default(0);
            $table->float('total_score')->default(0);
            $table->float('total_points')->default(0);
            $table->text('device_token')->nullable();
            $table->string('status')->default('enable');
            $table->integer('is_updated')->default(0)->comment('0- No,1- Yes');
            $table->date('c_date')->useCurrent();
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
        Schema::dropIfExists('users');
    }
}
