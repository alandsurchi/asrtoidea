import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_idea_generator/domain/models/idea_detail_model.dart';
import './idea_detail_state.dart';

final ideaDetailNotifierProvider = StateNotifierProvider.autoDispose
    .family<IdeaDetailNotifier, IdeaDetailState, String?>((ref, ideaId) {
      return IdeaDetailNotifier()..loadIdea(ideaId);
    });

class IdeaDetailNotifier extends StateNotifier<IdeaDetailState> {
  IdeaDetailNotifier() : super(const IdeaDetailState());

  void loadIdea(String? ideaId) {
    state = state.copyWith(isLoading: true);

    // Simulate loading with mock data
    final mockComments = [
      CommentModel(
        id: 'c1',
        authorName: 'Sarah Chen',
        authorAvatar: 'https://i.pravatar.cc/150?img=5',
        content:
            'This is a brilliant concept! The landing page approach will definitely increase conversion rates.',
        timeAgo: '2h ago',
        likes: 12,
        isLiked: false,
        replies: [
          CommentModel(
            id: 'c1r1',
            authorName: 'Alex Kim',
            authorAvatar: 'https://i.pravatar.cc/150?img=8',
            content:
                'Totally agree! We should also consider A/B testing different hero sections.',
            timeAgo: '1h ago',
            likes: 5,
            isLiked: true,
          ),
        ],
      ),
      CommentModel(
        id: 'c2',
        authorName: 'Marcus Johnson',
        authorAvatar: 'https://i.pravatar.cc/150?img=12',
        content:
            'Have you considered adding a video background? It could make the page more dynamic.',
        timeAgo: '4h ago',
        likes: 8,
        isLiked: false,
      ),
      CommentModel(
        id: 'c3',
        authorName: 'Priya Patel',
        authorAvatar: 'https://i.pravatar.cc/150?img=20',
        content:
            'The color scheme suggestion is spot on. Purple and gold always work well for premium brands.',
        timeAgo: '6h ago',
        likes: 15,
        isLiked: true,
      ),
    ];

    final mockIdea = IdeaDetailModel(
      id: ideaId ?? 'idea_1',
      title: 'Landing Page for Client',
      description:
          'Create a high-converting landing page with modern design principles, optimized for mobile-first experience.',
      category: 'Design',
      priority: 'High Priority',
      status: 'In Progress',
      backgroundImage: 'assets/images/img_rectangle_29_250x400.png',
      createdDate: 'Mar 20, 2026',
      deadline: 'Apr 5, 2026',
      teamMembers: [
        'https://i.pravatar.cc/150?img=5',
        'https://i.pravatar.cc/150?img=8',
        'https://i.pravatar.cc/150?img=12',
        'https://i.pravatar.cc/150?img=20',
      ],
      likeCount: 47,
      isLiked: false,
      isSaved: false,
      comments: mockComments,
      attachments: [
        'https://images.pexels.com/photos/196644/pexels-photo-196644.jpeg',
        'https://images.pexels.com/photos/1779487/pexels-photo-1779487.jpeg',
        'https://images.pexels.com/photos/265087/pexels-photo-265087.jpeg',
      ],
      fullContent: '''## Overview
This project involves designing and developing a premium landing page for our client in the SaaS industry. The goal is to create a visually stunning, high-converting page that communicates the product value proposition clearly.

## Key Objectives
- **Conversion Rate**: Target 5%+ conversion from visitor to trial signup
- **Performance**: Page load under 2 seconds
- **Mobile-First**: Fully responsive across all devices
- **Brand Alignment**: Match client's purple/gold brand identity

## Design Principles
The landing page will follow modern design trends with:
1. Bold hero section with animated gradient background
2. Social proof section with real customer testimonials
3. Feature showcase with interactive demos
4. Clear CTA buttons with micro-animations
5. Trust signals (security badges, client logos)

## Technical Stack
- Next.js for SSR and performance
- Framer Motion for animations
- Tailwind CSS for styling
- Vercel for deployment

## Timeline
- Week 1: Wireframes and design mockups
- Week 2: Development and animations
- Week 3: Testing and optimization
- Week 4: Launch and monitoring''',
    );

    state = state.copyWith(ideaDetail: mockIdea, isLoading: false);
  }

  void toggleLike() {
    final current = state.ideaDetail;
    if (current == null) return;
    state = state.copyWith(
      ideaDetail: current.copyWith(
        isLiked: !current.isLiked,
        likeCount: current.isLiked
            ? current.likeCount - 1
            : current.likeCount + 1,
      ),
    );
  }

  void toggleSave() {
    final current = state.ideaDetail;
    if (current == null) return;
    state = state.copyWith(
      ideaDetail: current.copyWith(isSaved: !current.isSaved),
    );
  }

  void toggleCommentLike(String commentId) {
    final current = state.ideaDetail;
    if (current == null) return;
    final updatedComments = current.comments.map((c) {
      if (c.id == commentId) {
        return c.copyWith(
          isLiked: !c.isLiked,
          likes: c.isLiked ? c.likes - 1 : c.likes + 1,
        );
      }
      return c;
    }).toList();
    state = state.copyWith(
      ideaDetail: current.copyWith(comments: updatedComments),
    );
  }

  void updateCommentText(String text) {
    state = state.copyWith(commentText: text);
  }

  void setReplyingTo(String? commentId) {
    if (commentId == null) {
      state = state.copyWith(clearReplyingTo: true, replyText: '');
    } else {
      state = state.copyWith(replyingToId: commentId, replyText: '');
    }
  }

  void updateReplyText(String text) {
    state = state.copyWith(replyText: text);
  }

  void addComment() {
    final current = state.ideaDetail;
    if (current == null || state.commentText.trim().isEmpty) return;

    final newComment = CommentModel(
      id: 'c${DateTime.now().millisecondsSinceEpoch}',
      authorName: 'You',
      authorAvatar: 'https://i.pravatar.cc/150?img=3',
      content: state.commentText.trim(),
      timeAgo: 'Just now',
      likes: 0,
    );

    state = state.copyWith(
      ideaDetail: current.copyWith(comments: [newComment, ...current.comments]),
      commentText: '',
    );
  }

  void addReply(String parentCommentId) {
    final current = state.ideaDetail;
    if (current == null || state.replyText.trim().isEmpty) return;

    final newReply = CommentModel(
      id: 'r${DateTime.now().millisecondsSinceEpoch}',
      authorName: 'You',
      authorAvatar: 'https://i.pravatar.cc/150?img=3',
      content: state.replyText.trim(),
      timeAgo: 'Just now',
      likes: 0,
    );

    final updatedComments = current.comments.map((c) {
      if (c.id == parentCommentId) {
        return c.copyWith(replies: [...c.replies, newReply]);
      }
      return c;
    }).toList();

    state = state.copyWith(
      ideaDetail: current.copyWith(comments: updatedComments),
      clearReplyingTo: true,
      replyText: '',
    );
  }

  void updateStatus(String newStatus) {
    final current = state.ideaDetail;
    if (current == null) return;
    state = state.copyWith(ideaDetail: current.copyWith(status: newStatus));
  }
}
