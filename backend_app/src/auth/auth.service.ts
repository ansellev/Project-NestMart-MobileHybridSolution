import {
  Injectable,
  UnauthorizedException,
  BadRequestException
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { JwtService } from '@nestjs/jwt';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcrypt';

import { User, UserRole } from './user.entity';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,

    private readonly jwtService: JwtService,
  ) {}

  async register(body: RegisterDto) {
    const existingUser = await this.userRepository.findOne({
      where: {
        email: body.email,
      },
    });

    if (existingUser) {
      return {
        success: false,
        message: 'Email already exists',
      };
    }

    const hashedPassword = await bcrypt.hash(
      body.password,
      10,
    );

    const user = this.userRepository.create({
      name: body.name,
      email: body.email,
      password: hashedPassword,
      role: UserRole.BUYER,
    });

    await this.userRepository.save(user);

    return {
      success: true,
      message: 'Register success',
    };
  }

  async login(body: LoginDto) {
    const user = await this.userRepository.findOne({
      where: {
        email: body.email,
      },
    });

    if (!user) {
      throw new UnauthorizedException(
        'Invalid email or password',
      );
    }

    const validPassword = await bcrypt.compare(
      body.password,
      user.password,
    );

    if (!validPassword) {
      throw new UnauthorizedException(
        'Invalid email or password',
      );
    }

    const payload = {
      id: user.id,
      email: user.email,
      role: user.role,
    };

    const accessToken =
      this.jwtService.sign(payload);

    return {
      success: true,
      access_token: accessToken,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role,
      },
    };
  }

  async getProfile(id: number) {
    const user =
      await this.userRepository.findOne({
        where: { id },
      });

    if (!user) {
      return {
        success: false,
        message: 'User not found',
      };
    }

    return {
      success: true,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role,
      },
    };
  }

  async updateProfile(
  id: number,
  data: {
    name?: string;
    email?: string;
    currentPassword?: string;
    newPassword?: string;
  },
) {
  const user = await this.userRepository.findOne({
    where: { id },
  });

  if (!user) {
    return {
      success: false,
      message: 'User not found',
    };
  }

  // update nama
  if (data.name && data.name.trim() !== '') {
    user.name = data.name.trim();
  }

  // update email
  if (data.email && data.email !== user.email) {
    const emailExists = await this.userRepository.findOne({
      where: {
        email: data.email,
      },
    });

    if (emailExists) {
      throw new BadRequestException(
        'Email already exists',
      );
    }

    user.email = data.email;
  }

  // update password
  if (
    data.currentPassword &&
    data.newPassword &&
    data.newPassword.trim() !== ''
  ) {
    const valid = await bcrypt.compare(
      data.currentPassword,
      user.password,
    );

    if (!valid) {
      throw new BadRequestException(
        'Current password is incorrect',
      );
    }

    user.password = await bcrypt.hash(
      data.newPassword,
      10,
    );
  }

  await this.userRepository.save(user);

  return {
    success: true,
    message: 'Profile updated successfully',
    user: {
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
    },
  };
}
}