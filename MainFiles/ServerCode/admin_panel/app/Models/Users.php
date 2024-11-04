<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Users extends Model
{
    use HasFactory;

    protected $table = 'tbl_user';
    protected $guarded = array();

    protected $hidden = [
        'password',
    ];

    protected $casts = [
        'id' => 'integer',
        'username' => 'string',
        'fullname' => 'string',
        'email' => 'string',
        'password' => 'string',
        'mobile_number' => 'string',
        'profile_img' => 'string',
        'type' => 'integer',
        'instagram_url' => 'string',
        'facebook_url' => 'string',
        'twitter_url' => 'string',
        'biodata' => 'string',
        'address' => 'string',
        'reference_code' => 'string',
        'parent_reference_code' => 'string',
        'pratice_quiz_score' => 'integer',
        'total_score' => 'integer',
        'total_points' => 'integer',
        'device_type' => 'integer',
        'device_token' => 'string',
        'status' => 'string',
        'is_updated' => 'integer',
    ];
}
