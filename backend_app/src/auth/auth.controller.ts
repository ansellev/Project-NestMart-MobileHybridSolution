import {
  Controller,
  Post,
  Get,
  Body,
  Request,
  UseGuards,
  Param,
  Patch,
} from '@nestjs/common';

import { AuthService } from './auth.service';

import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';

import { JwtAuthGuard } from './jwt/jwt-auth.guard';
import { UpdateProfileDto } from './dto/update-profile.dto';

@Controller('auth')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
  ) {}

  @Post('register')
  register(
    @Body() body: RegisterDto,
  ) {
    return this.authService.register(body);
  }

  @Post('login')
  login(
    @Body() body: LoginDto,
  ) {
    return this.authService.login(body);
  }

  @UseGuards(JwtAuthGuard)
  @Get('profile')
  profile(
    @Request() req,
  ) {
    return this.authService.getProfile(
      req.user.id,
    );
  }

  @Get('profile/:id')
async getProfile(
  @Param('id') id: number,
) {
  return this.authService.getProfile(Number(id));
}

@Patch('profile/:id')
async updateProfile(
  @Param('id') id: number,
  @Body() body: UpdateProfileDto,
) {
  return this.authService.updateProfile(
    Number(id),
    body,
  );
}
}